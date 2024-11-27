# Maven {#maven}

Maven is a well-known build tool for the Java ecosystem however it has some challenges when integrating into the Nix build system.

The following provides a list of common patterns with how to package a Maven project (or any JVM language that can export to Maven) as a Nix package.

## Building a package using `maven.buildMavenPackage` {#maven-buildmavenpackage}

Consider the following package:

```nix
{ lib, fetchFromGitHub, jre, makeWrapper, maven }:

maven.buildMavenPackage rec {
  pname = "jd-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "intoolswetrust";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-rRttA5H0A0c44loBzbKH7Waoted3IsOgxGCD2VM0U/Q=";
  };

  mvnHash = "sha256-kLpjMj05uC94/5vGMwMlFzLKNFOKeyNvq/vmB6pHTAo=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/jd-cli
    install -Dm644 jd-cli/target/jd-cli.jar $out/share/jd-cli

    makeWrapper ${jre}/bin/java $out/bin/jd-cli \
      --add-flags "-jar $out/share/jd-cli/jd-cli.jar"
  '';

  meta = {
    description = "Simple command line wrapper around JD Core Java Decompiler project";
    homepage = "https://github.com/intoolswetrust/jd-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ majiir ];
  };
}
```

This package calls `maven.buildMavenPackage` to do its work. The primary difference from `stdenv.mkDerivation` is the `mvnHash` variable, which is a hash of all of the Maven dependencies.

::: {.tip}
After setting `maven.buildMavenPackage`, we then do standard Java `.jar` installation by saving the `.jar` to `$out/share/java` and then making a wrapper which allows executing that file; see [](#sec-language-java) for additional generic information about packaging Java applications.
:::

### Stable Maven plugins {#stable-maven-plugins}

Maven defines default versions for its core plugins, e.g. `maven-compiler-plugin`. If your project does not override these versions, an upgrade of Maven will change the version of the used plugins, and therefore the derivation and hash.

When `maven` is upgraded, `mvnHash` for the derivation must be updated as well: otherwise, the project will be built on the derivation of old plugins, and fail because the requested plugins are missing.

This clearly prevents automatic upgrades of Maven: a manual effort must be made throughout nixpkgs by any maintainer wishing to push the upgrades.

To make sure that your package does not add extra manual effort when upgrading Maven, explicitly define versions for all plugins. You can check if this is the case by adding the following plugin to your (parent) POM:

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-enforcer-plugin</artifactId>
  <version>3.3.0</version>
  <executions>
    <execution>
      <id>enforce-plugin-versions</id>
      <goals>
        <goal>enforce</goal>
      </goals>
      <configuration>
        <rules>
          <requirePluginVersions />
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

