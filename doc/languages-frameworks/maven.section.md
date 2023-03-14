# Maven {#maven}

Maven is a well-known build tool for the Java ecosystem however it has some challenges when integrating into the Nix build system.

The following provides a list of common patterns with how to package a Maven project (or any JVM language that can export to Maven) as a Nix package.

For the purposes of this example let's consider a very basic Maven project with the following `pom.xml` with a single dependency on [emoji-java](https://github.com/vdurmont/emoji-java).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>io.github.fzakaria</groupId>
  <artifactId>maven-demo</artifactId>
  <version>1.0</version>
  <packaging>jar</packaging>
  <name>NixOS Maven Demo</name>

  <dependencies>
    <dependency>
        <groupId>com.vdurmont</groupId>
        <artifactId>emoji-java</artifactId>
        <version>5.1.1</version>
      </dependency>
  </dependencies>
</project>
```

Our main class file will be very simple:

```java
import com.vdurmont.emoji.EmojiParser;

public class Main {
  public static void main(String[] args) {
    String str = "NixOS :grinning: is super cool :smiley:!";
    String result = EmojiParser.parseToUnicode(str);
    System.out.println(result);
  }
}
```

You find this demo project at https://github.com/fzakaria/nixos-maven-example

## Solving for dependencies {#solving-for-dependencies}

### buildMaven with NixOS/mvn2nix-maven-plugin {#buildmaven-with-nixosmvn2nix-maven-plugin}

> ⚠️ Although `buildMaven` is the "blessed" way within nixpkgs, as of 2020, it hasn't seen much activity in quite a while.

`buildMaven` is an alternative method that tries to follow similar patterns of other programming languages by generating a lock file. It relies on the maven plugin [mvn2nix-maven-plugin](https://github.com/NixOS/mvn2nix-maven-plugin).

First you generate a `project-info.json` file using the maven plugin.

> This should be executed in the project's source repository or be told which `pom.xml` to execute with.

```bash
# run this step within the project's source repository
❯ mvn org.nixos.mvn2nix:mvn2nix-maven-plugin:mvn2nix

❯ cat project-info.json | jq | head
{
  "project": {
    "artifactId": "maven-demo",
    "groupId": "org.nixos",
    "version": "1.0",
    "classifier": "",
    "extension": "jar",
    "dependencies": [
      {
        "artifactId": "maven-resources-plugin",
```

This file is then given to the `buildMaven` function, and it returns 2 attributes.

**`repo`**:
    A Maven repository that is a symlink farm of all the dependencies found in the `project-info.json`


**`build`**:
    A simple derivation that runs through `mvn compile` & `mvn package` to build the JAR. You may use this as inspiration for more complicated derivations.

Here is an [example](https://github.com/fzakaria/nixos-maven-example/blob/main/build-maven-repository.nix) of building the Maven repository

```nix
{ pkgs ? import <nixpkgs> { } }:
with pkgs;
(buildMaven ./project-info.json).repo
```

The benefit over the _double invocation_ as we will see below, is that the _/nix/store_ entry is a _linkFarm_ of every package, so that changes to your dependency set doesn't involve downloading everything from scratch.

```bash
❯ tree $(nix-build --no-out-link build-maven-repository.nix) | head
/nix/store/g87va52nkc8jzbmi1aqdcf2f109r4dvn-maven-repository
├── antlr
│   └── antlr
│       └── 2.7.2
│           ├── antlr-2.7.2.jar -> /nix/store/d027c8f2cnmj5yrynpbq2s6wmc9cb559-antlr-2.7.2.jar
│           └── antlr-2.7.2.pom -> /nix/store/mv42fc5gizl8h5g5vpywz1nfiynmzgp2-antlr-2.7.2.pom
├── avalon-framework
│   └── avalon-framework
│       └── 4.1.3
│           ├── avalon-framework-4.1.3.jar -> /nix/store/iv5fp3955w3nq28ff9xfz86wvxbiw6n9-avalon-framework-4.1.3.jar
```

### Double Invocation {#double-invocation}

> ⚠️ This pattern is the simplest but may cause unnecessary rebuilds due to the output hash changing.

The double invocation is a _simple_ way to get around the problem that `nix-build` may be sandboxed and have no Internet connectivity.

It treats the entire Maven repository as a single source to be downloaded, relying on Maven's dependency resolution to satisfy the output hash. This is similar to fetchers like `fetchgit`, except it has to run a Maven build to determine what to download.

The first step will be to build the Maven project as a fixed-output derivation in order to collect the Maven repository -- below is an [example](https://github.com/fzakaria/nixos-maven-example/blob/main/double-invocation-repository.nix).

> Traditionally the Maven repository is at `~/.m2/repository`. We will override this to be the `$out` directory.

```nix
{ lib, stdenv, maven }:
stdenv.mkDerivation {
  name = "maven-repository";
  buildInputs = [ maven ];
  src = ./.; # or fetchFromGitHub, cleanSourceWith, etc
  buildPhase = ''
    mvn package -Dmaven.repo.local=$out
  '';

  # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
  installPhase = ''
    find $out -type f \
      -name \*.lastUpdated -or \
      -name resolver-status.properties -or \
      -name _remote.repositories \
      -delete
  '';

  # don't do any fixup
  dontFixup = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  # replace this with the correct SHA256
  outputHash = lib.fakeSha256;
}
```

The build will fail, and tell you the expected `outputHash` to place. When you've set the hash, the build will return with a `/nix/store` entry whose contents are the full Maven repository.

> Some additional files are deleted that would cause the output hash to change potentially on subsequent runs.

```bash
❯ tree $(nix-build --no-out-link double-invocation-repository.nix) | head
/nix/store/8kicxzp98j68xyi9gl6jda67hp3c54fq-maven-repository
├── backport-util-concurrent
│   └── backport-util-concurrent
│       └── 3.1
│           ├── backport-util-concurrent-3.1.pom
│           └── backport-util-concurrent-3.1.pom.sha1
├── classworlds
│   └── classworlds
│       ├── 1.1
│       │   ├── classworlds-1.1.jar
```

If your package uses _SNAPSHOT_ dependencies or _version ranges_; there is a strong likelihood that over-time your output hash will change since the resolved dependencies may change. Hence this method is less recommended then using `buildMaven`.

## Building a JAR {#building-a-jar}

Regardless of which strategy is chosen above, the step to build the derivation is the same.

```nix
{ stdenv, maven, callPackage }:
# pick a repository derivation, here we will use buildMaven
let repository = callPackage ./build-maven-repository.nix { };
in stdenv.mkDerivation rec {
  pname = "maven-demo";
  version = "1.0";

  src = builtins.fetchTarball "https://github.com/fzakaria/nixos-maven-example/archive/main.tar.gz";
  buildInputs = [ maven ];

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn --offline -Dmaven.repo.local=${repository} package;
  '';

  installPhase = ''
    install -Dm644 target/${pname}-${version}.jar $out/share/java
  '';
}
```

> We place the library in `$out/share/java` since JDK package has a _stdenv setup hook_ that adds any JARs in the `share/java` directories of the build inputs to the CLASSPATH environment.

```bash
❯ tree $(nix-build --no-out-link build-jar.nix)
/nix/store/7jw3xdfagkc2vw8wrsdv68qpsnrxgvky-maven-demo-1.0
└── share
    └── java
        └── maven-demo-1.0.jar

2 directories, 1 file
```

## Runnable JAR {#runnable-jar}

The previous example builds a `jar` file but that's not a file one can run.

You need to use it with `java -jar $out/share/java/output.jar` and make sure to provide the required dependencies on the classpath.

The following explains how to use `makeWrapper` in order to make the derivation produce an executable that will run the JAR file you created.

We will use the same repository we built above (either _double invocation_ or _buildMaven_) to setup a CLASSPATH for our JAR.

The following two methods are more suited to Nix then building an [UberJar](https://imagej.net/Uber-JAR) which may be the more traditional approach.

### CLASSPATH {#classpath}

> This is ideal if you are providing a derivation for _nixpkgs_ and don't want to patch the project's `pom.xml`.

We will read the Maven repository and flatten it to a single list. This list will then be concatenated with the _CLASSPATH_ separator to create the full classpath.

We make sure to provide this classpath to the `makeWrapper`.

```nix
{ stdenv, maven, callPackage, makeWrapper, jre }:
let
  repository = callPackage ./build-maven-repository.nix { };
in stdenv.mkDerivation rec {
  pname = "maven-demo";
  version = "1.0";

  src = builtins.fetchTarball
    "https://github.com/fzakaria/nixos-maven-example/archive/main.tar.gz";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ maven ];

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn --offline -Dmaven.repo.local=${repository} package;
  '';

  installPhase = ''
    mkdir -p $out/bin

    classpath=$(find ${repository} -name "*.jar" -printf ':%h/%f');
    install -Dm644 target/${pname}-${version}.jar $out/share/java
    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
          --add-flags "-classpath $out/share/java/${pname}-${version}.jar:''${classpath#:}" \
          --add-flags "Main"
  '';
}
```

### MANIFEST file via Maven Plugin {#manifest-file-via-maven-plugin}

> This is ideal if you are the project owner and want to change your `pom.xml` to set the CLASSPATH within it.

Augment the `pom.xml` to create a JAR with the following manifest:

```xml
<build>
  <plugins>
    <plugin>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
            <archive>
                <manifest>
                    <addClasspath>true</addClasspath>
                    <classpathPrefix>../../repository/</classpathPrefix>
                    <classpathLayoutType>repository</classpathLayoutType>
                    <mainClass>Main</mainClass>
                </manifest>
                <manifestEntries>
                    <Class-Path>.</Class-Path>
                </manifestEntries>
            </archive>
        </configuration>
    </plugin>
  </plugins>
</build>
```

The above plugin instructs the JAR to look for the necessary dependencies in the `lib/` relative folder. The layout of the folder is also in the _maven repository_ style.

```bash
❯ unzip -q -c $(nix-build --no-out-link runnable-jar.nix)/share/java/maven-demo-1.0.jar META-INF/MANIFEST.MF

Manifest-Version: 1.0
Archiver-Version: Plexus Archiver
Built-By: nixbld
Class-Path: . ../../repository/com/vdurmont/emoji-java/5.1.1/emoji-jav
 a-5.1.1.jar ../../repository/org/json/json/20170516/json-20170516.jar
Created-By: Apache Maven 3.6.3
Build-Jdk: 1.8.0_265
Main-Class: Main
```

We will modify the derivation above to add a symlink to our repository so that it's accessible to our JAR during the `installPhase`.

```nix
{ stdenv, maven, callPackage, makeWrapper, jre }:
# pick a repository derivation, here we will use buildMaven
let repository = callPackage ./build-maven-repository.nix { };
in stdenv.mkDerivation rec {
  pname = "maven-demo";
  version = "1.0";

  src = builtins.fetchTarball
    "https://github.com/fzakaria/nixos-maven-example/archive/main.tar.gz";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ maven ];

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn --offline -Dmaven.repo.local=${repository} package;
  '';

  installPhase = ''
    mkdir -p $out/bin

    # create a symbolic link for the repository directory
    ln -s ${repository} $out/repository

    install -Dm644 target/${pname}-${version}.jar $out/share/java
    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';
}
```

> Our script produces a dependency on `jre` rather than `jdk` to restrict the runtime closure necessary to run the application.

This will give you an executable shell-script that launches your JAR with all the dependencies available.

```bash
❯ tree $(nix-build --no-out-link runnable-jar.nix)
/nix/store/8d4c3ibw8ynsn01ibhyqmc1zhzz75s26-maven-demo-1.0
├── bin
│   └── maven-demo
├── repository -> /nix/store/g87va52nkc8jzbmi1aqdcf2f109r4dvn-maven-repository
└── share
    └── java
        └── maven-demo-1.0.jar

❯ $(nix-build --no-out-link --option tarball-ttl 1 runnable-jar.nix)/bin/maven-demo
NixOS 😀 is super cool 😃!
```
