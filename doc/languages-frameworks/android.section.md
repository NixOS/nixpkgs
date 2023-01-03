# Android {#android}

The Android build environment provides three major features and a number of
supporting features.

## Deploying an Android SDK installation with plugins {#deploying-an-android-sdk-installation-with-plugins}

The first use case is deploying the SDK with a desired set of plugins or subsets
of an SDK.

```nix
with import <nixpkgs> {};

let
  androidComposition = androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformToolsVersion = "30.0.5";
    buildToolsVersions = [ "30.0.3" ];
    includeEmulator = false;
    emulatorVersion = "30.3.4";
    platformVersions = [ "28" "29" "30" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    ndkVersions = ["22.0.7026061"];
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
* `buildToolsVersions` specifies the versions of the `build-tools` plugins to
  use.
* `includeEmulator` specifies whether to deploy the emulator package (`false`
  by default). When enabled, the version of the emulator to deploy can be
  specified by setting the `emulatorVersion` parameter.
* `cmakeVersions` specifies which CMake versions should be deployed.
* `includeNDK` specifies that the Android NDK bundle should be included.
  Defaults to: `false`.
* `ndkVersions` specifies the NDK versions that we want to use. These are linked
  under the `ndk` directory of the SDK root, and the first is linked under the
  `ndk-bundle` directory.
* `ndkVersion` is equivalent to specifying one entry in `ndkVersions`, and
  `ndkVersions` overrides this parameter if provided.
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

You can specify license names:

* `extraLicenses` is a list of license names.
  You can get these names from repo.json or `querypackages.sh licenses`. The SDK
  license (`android-sdk-license`) is accepted for you if you set accept_license
  to true. If you are doing something like working with preview SDKs, you will
  want to add `android-sdk-preview-license` or whichever license applies here.

Additionally, you can override the repositories that composeAndroidPackages will
pull from:

* `repoJson` specifies a path to a generated repo.json file. You can generate this
  by running `generate.sh`, which in turn will call into `mkrepo.rb`.
* `repoXmls` is an attribute set containing paths to repo XML files. If specified,
  it takes priority over `repoJson`, and will trigger a local build writing out a
  repo.json to the Nix store based on the given repository XMLs.

```nix
repoXmls = {
  packages = [ ./xml/repository2-1.xml ];
  images = [
    ./xml/android-sys-img2-1.xml
    ./xml/android-tv-sys-img2-1.xml
    ./xml/android-wear-sys-img2-1.xml
    ./xml/android-wear-cn-sys-img2-1.xml
    ./xml/google_apis-sys-img2-1.xml
    ./xml/google_apis_playstore-sys-img2-1.xml
  ];
  addons = [ ./xml/addon2-1.xml ];
};
```

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

## Using predefined Android package compositions {#using-predefined-android-package-compositions}

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

## Building an Android application {#building-an-android-application}

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
[Hydra](https://nixos.org/hydra): the Nix-based continuous integration solution
to build Android apps. An Android APK gets exposed as a build product and can be
installed on any Android device with a web browser by navigating to the build
result page.

## Spawning emulator instances {#spawning-emulator-instances}

For testing purposes, it can also be quite convenient to automatically generate
scripts that spawn emulator instances with all desired configuration settings.

An emulator spawn script can be configured by invoking the `emulateApp {}`
function:

```nix
with import <nixpkgs> {};

androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "28";
  abiVersion = "x86"; # armeabi-v7a, mips, x86_64
  systemImageType = "google_apis_playstore";
}
```

Additional flags may be applied to the Android SDK's emulator through the runtime environment variable `$NIX_ANDROID_EMULATOR_FLAGS`.

It is also possible to specify an APK to deploy inside the emulator
and the package and activity names to launch it:

```nix
with import <nixpkgs> {};

androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "24";
  abiVersion = "armeabi-v7a"; # mips, x86, x86_64
  systemImageType = "default";
  app = ./MyApp.apk;
  package = "MyApp";
  activity = "MainActivity";
}
```

In addition to prebuilt APKs, you can also bind the APK parameter to a
`buildApp {}` function invocation shown in the previous example.

## Notes on environment variables in Android projects {#notes-on-environment-variables-in-android-projects}

* `ANDROID_SDK_ROOT` should point to the Android SDK. In your Nix expressions, this should be
  `${androidComposition.androidsdk}/libexec/android-sdk`. Note that `ANDROID_HOME` is deprecated,
  but if you rely on tools that need it, you can export it too.
* `ANDROID_NDK_ROOT` should point to the Android NDK, if you're doing NDK development.
  In your Nix expressions, this should be `${ANDROID_SDK_ROOT}/ndk-bundle`.

If you are running the Android Gradle plugin, you need to export GRADLE_OPTS to override aapt2
to point to the aapt2 binary in the Nix store as well, or use a FHS environment so the packaged
aapt2 can run. If you don't want to use a FHS environment, something like this should work:

```nix
let
  buildToolsVersion = "30.0.3";

  # Use buildToolsVersion when you define androidComposition
  androidComposition = <...>;
in
pkgs.mkShell rec {
  ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

  # Use the same buildToolsVersion here
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";
}
```

If you are using cmake, you need to add it to PATH in a shell hook or FHS env profile.
The path is suffixed with a build number, but properly prefixed with the version.
So, something like this should suffice:

```nix
let
  cmakeVersion = "3.10.2";

  # Use cmakeVersion when you define androidComposition
  androidComposition = <...>;
in
pkgs.mkShell rec {
  ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

  # Use the same cmakeVersion here
  shellHook = ''
    export PATH="$(echo "$ANDROID_SDK_ROOT/cmake/${cmakeVersion}".*/bin):$PATH"
  '';
}
```

Note that running Android Studio with ANDROID_SDK_ROOT set will automatically write a
`local.properties` file with `sdk.dir` set to $ANDROID_SDK_ROOT if one does not already
exist. If you are using the NDK as well, you may have to add `ndk.dir` to this file.

An example shell.nix that does all this for you is provided in examples/shell.nix.
This shell.nix includes a shell hook that overwrites local.properties with the correct
sdk.dir and ndk.dir values. This will ensure that the SDK and NDK directories will
both be correct when you run Android Studio inside nix-shell.

## Notes on improving build.gradle compatibility {#notes-on-improving-build.gradle-compatibility}

Ensure that your buildToolsVersion and ndkVersion match what is declared in androidenv.
If you are using cmake, make sure its declared version is correct too.

Otherwise, you may get cryptic errors from aapt2 and the Android Gradle plugin warning
that it cannot install the build tools because the SDK directory is not writeable.

```gradle
android {
    buildToolsVersion "30.0.3"
    ndkVersion = "22.0.7026061"
    externalNativeBuild {
        cmake {
            version "3.10.2"
        }
    }
}

```

## Querying the available versions of each plugin {#querying-the-available-versions-of-each-plugin}

repo.json provides all the options in one file now.

A shell script in the `pkgs/development/mobile/androidenv/` subdirectory can be used to retrieve all
possible options:

```bash
./querypackages.sh packages
```

The above command-line instruction queries all package versions in repo.json.

## Updating the generated expressions {#updating-the-generated-expressions}

repo.json is generated from XML files that the Android Studio package manager uses.
To update the expressions run the `generate.sh` script that is stored in the
`pkgs/development/mobile/androidenv/` subdirectory:

```bash
./generate.sh
```
