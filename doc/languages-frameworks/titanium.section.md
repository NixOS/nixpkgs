---
title: Titanium
author: Sander van der Burg
date: 2018-11-18
---
# Titanium

The Nixpkgs repository contains facilities to deploy a variety of versions of
the [Titanium SDK](https://www.appcelerator.com) versions, a cross-platform
mobile app development framework using JavaScript as an implementation language,
and includes a function abstraction making it possible to build Titanium
applications for Android and iOS devices from source code.

Not all Titanium features supported -- currently, it can only be used to build
Android and iOS apps.

Building a Titanium app
-----------------------
We can build a Titanium app from source for Android or iOS and for debugging or
release purposes by invoking the `titaniumenv.buildApp {}` function:

```nix
titaniumenv.buildApp {
  name = "myapp";
  src = ./myappsource;

  preBuild = "";
  target = "android"; # or 'iphone'
  tiVersion = "7.1.0.GA";
  release = true;

  androidsdkArgs = {
    platformVersions = [ "25" "26" ];
  };
  androidKeyStore = ./keystore;
  androidKeyAlias = "myfirstapp";
  androidKeyStorePassword = "secret";

  xcodeBaseDir = "/Applications/Xcode.app";
  xcodewrapperArgs = {
    version = "9.3";
  };
  iosMobileProvisioningProfile = ./myprovisioning.profile;
  iosCertificateName = "My Company";
  iosCertificate = ./mycertificate.p12;
  iosCertificatePassword = "secret";
  iosVersion = "11.3";
  iosBuildStore = false;

  enableWirelessDistribution = true;
  installURL = "/installipa.php";
}
```

The `titaniumenv.buildApp {}` function takes the following parameters:

* The `name` parameter refers to the name in the Nix store.
* The `src` parameter refers to the source code location of the app that needs
  to be built.
* `preRebuild` contains optional build instructions that are carried out before
  the build starts.
* `target` indicates for which device the app must be built. Currently only
  'android' and 'iphone' (for iOS) are supported.
* `tiVersion` can be used to optionally override the requested Titanium version
  in `tiapp.xml`. If not specified, it will use the version in `tiapp.xml`.
* `release` should be set to true when building an app for submission to the
  Google Playstore or Apple Appstore. Otherwise, it should be false.

When the `target` has been set to `android`, we can configure the following
parameters:

* The `androidSdkArgs` parameter refers to an attribute set that propagates all
  parameters to the `androidenv.composeAndroidPackages {}` function. This can
  be used to install all relevant Android plugins that may be needed to perform
  the Android build. If no parameters are given, it will deploy the platform
  SDKs for API-levels 25 and 26 by default.

When the `release` parameter has been set to true, you need to provide
parameters to sign the app:

* `androidKeyStore` is the path to the keystore file
* `androidKeyAlias` is the key alias
* `androidKeyStorePassword` refers to the password to open the keystore file.

When the `target` has been set to `iphone`, we can configure the following
parameters:

* The `xcodeBaseDir` parameter refers to the location where Xcode has been
  installed. When none value is given, the above value is the default.
* The `xcodewrapperArgs` parameter passes arbitrary parameters to the
  `xcodeenv.composeXcodeWrapper {}` function. This can, for example, be used
  to adjust the default version of Xcode.

When `release` has been set to true, you also need to provide the following
parameters:

* `iosMobileProvisioningProfile` refers to a mobile provisioning profile needed
  for signing.
* `iosCertificateName` refers to the company name in the P12 certificate.
* `iosCertificate` refers to the path to the P12 file.
* `iosCertificatePassword` contains the password to open the P12 file.
* `iosVersion` refers to the iOS SDK version to use. It defaults to the latest
  version.
* `iosBuildStore` should be set to `true` when building for the Apple Appstore
  submission. For enterprise or ad-hoc builds it should be set to `false`.

When `enableWirelessDistribution` has been enabled, you must also provide the
path of the PHP script (`installURL`) (that is included with the iOS build
environment) to enable wireless ad-hoc installations.

Emulating or simulating the app
-------------------------------
It is also possible to simulate the correspond iOS simulator build by using
`xcodeenv.simulateApp {}` and emulate an Android APK by using
`androidenv.emulateApp {}`.
