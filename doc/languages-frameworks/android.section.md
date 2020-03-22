---
title: Android
author: Sander van der Burg
date: 2018-11-18
---
# Android

The Android build environment provides three major features and a number of
supporting features.

Deploying an Android SDK installation with plugins
--------------------------------------------------
The first use case is deploying the SDK with a desired set of plugins or subsets
of an SDK.

```nix
with import <nixpkgs> {};

let
  androidComposition = androidenv.composeAndroidPackages {
    toolsVersion = "25.2.5";
    platformToolsVersion = "27.0.1";
    buildToolsVersions = [ "27.0.3" ];
    includeEmulator = false;
    emulatorVersion = "27.2.0";
    platformVersions = [ "24" ];
    includeSources = false;
    includeDocs = false;
    includeSystemImages = false;
    systemImageTypes = [ "default" ];
    abiVersions = [ "armeabi-v7a" ];
    lldbVersions = [ "2.0.2558144" ];
    cmakeVersions = [ "3.6.4111459" ];
    includeNDK = false;
    ndkVersion = "16.1.4479499";
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
in
androidComposition.androidsdk
```

The above function invocation states that we want an Android SDK with the above
specified plugin versions. By default, most plugins are disabled. Notable
exceptions are the tools, platform-tools and build-tools sub packages.

The following parameters are supported:

* `toolsVersion`, specifies the version of the tools package to use
* `platformsToolsVersion` specifies the version of the `platform-tools` plugin
* `buildToolsVersion` specifies the versions of the `build-tools` plugins to
  use.
* `includeEmulator` specifies whether to deploy the emulator package (`false`
  by default). When enabled, the version of the emulator to deploy can be
  specified by setting the `emulatorVersion` parameter.
* `includeDocs` specifies whether the documentation catalog should be included.
* `lldbVersions` specifies what LLDB versions should be deployed.
* `cmakeVersions` specifies which CMake versions should be deployed.
* `includeNDK` specifies that the Android NDK bundle should be included.
  Defaults to: `false`.
* `ndkVersion` specifies the NDK version that we want to use.
* `includeExtras` is an array of identifier strings referring to arbitrary
  add-on packages that should be installed.
* `platformVersions` specifies which platform SDK versions should be included.

For each platform version that has been specified, we can apply the following
options:

* `includeSystemImages` specifies whether a system image for each platform SDK
  should be included.
* `includeSources` specifies whether the sources for each SDK version should be
  included.
* `useGoogleAPIs` specifies that for each selected platform version the
  Google API should be included.
* `useGoogleTVAddOns` specifies that for each selected platform version the
  Google TV add-on should be included.

For each requested system image we can specify the following options:

* `systemImageTypes` specifies what kind of system images should be included.
  Defaults to: `default`.
* `abiVersions` specifies what kind of ABI version of each system image should
  be included. Defaults to: `armeabi-v7a`.

Most of the function arguments have reasonable default settings.

When building the above expression with:

```bash
$ nix-build
```

The Android SDK gets deployed with all desired plugin versions.

We can also deploy subsets of the Android SDK. For example, to only the
`platform-tools` package, you can evaluate the following expression:

```nix
with import <nixpkgs> {};

let
  androidComposition = androidenv.composeAndroidPackages {
    # ...
  };
in
androidComposition.platform-tools
```

Using predefine Android package compositions
--------------------------------------------
In addition to composing an Android package set manually, it is also possible
to use a predefined composition that contains all basic packages for a specific
Android version, such as version 9.0 (API-level 28).

The following Nix expression can be used to deploy the entire SDK with all basic
plugins:

```nix
with import <nixpkgs> {};

androidenv.androidPkgs_9_0.androidsdk
```

It is also possible to use one plugin only:

```nix
with import <nixpkgs> {};

androidenv.androidPkgs_9_0.platform-tools
```

Building an Android application
-------------------------------
In addition to the SDK, it is also possible to build an Ant-based Android
project and automatically deploy all the Android plugins that a project
requires.

```nix
with import <nixpkgs> {};

androidenv.buildApp {
  name = "MyAndroidApp";
  src = ./myappsources;
  release = true;

  # If release is set to true, you need to specify the following parameters
  keyStore = ./keystore;
  keyAlias = "myfirstapp";
  keyStorePassword = "mykeystore";
  keyAliasPassword = "myfirstapp";

  # Any Android SDK parameters that install all the relevant plugins that a
  # build requires
  platformVersions = [ "24" ];

  # When we include the NDK, then ndk-build is invoked before Ant gets invoked
  includeNDK = true;
}
```

Aside from the app-specific build parameters (`name`, `src`, `release` and
keystore parameters), the `buildApp {}` function supports all the function
parameters that the SDK composition function (the function shown in the
previous section) supports.

This build function is particularly useful when it is desired to use
[Hydra](http://nixos.org/hydra): the Nix-based continuous integration solution
to build Android apps. An Android APK gets exposed as a build product and can be
installed on any Android device with a web browser by navigating to the build
result page.

Spawning emulator instances
---------------------------
For testing purposes, it can also be quite convenient to automatically generate
scripts that spawn emulator instances with all desired configuration settings.

An emulator spawn script can be configured by invoking the `emulateApp {}`
function:

```nix
with import <nixpkgs> {};

androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "28";
  abiVersion = "x86_64"; # armeabi-v7a, mips, x86
  systemImageType = "google_apis_playstore";
}
```

It is also possible to specify an APK to deploy inside the emulator
and the package and activity names to launch it:

```nix
with import <nixpkgs> {};

androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "24";
  abiVersion = "armeabi-v7a"; # mips, x86, x86_64
  systemImageType = "default";
  useGoogleAPIs = false;
  app = ./MyApp.apk;
  package = "MyApp";
  activity = "MainActivity";
}
```

In addition to prebuilt APKs, you can also bind the APK parameter to a
`buildApp {}` function invocation shown in the previous example.

Querying the available versions of each plugin
----------------------------------------------
When using any of the previously shown functions, it may be a bit inconvenient
to find out what options are supported, since the Android SDK provides many
plugins.

A shell script in the `pkgs/development/mobile/androidenv/` sub directory can be used to retrieve all
possible options:

```bash
sh ./querypackages.sh packages build-tools
```

The above command-line instruction queries all build-tools versions in the
generated `packages.nix` expression.

Updating the generated expressions
----------------------------------
Most of the Nix expressions are generated from XML files that the Android
package manager uses. To update the expressions run the `generate.sh` script
that is stored in the `pkgs/development/mobile/androidenv/` sub directory:

```bash
./generate.sh
```
