{
  lib,
  config,
  sdkPlatform,
}:

self: super: {
  preBuild = super.preBuild or "" + ''
    platformPath=$out/Platforms/${sdkPlatform}.platform
    sdkpath=$platformPath/Developer/SDKs
  '';

  preInstall = super.preInstall or "" + ''
    platformPath=$out/Platforms/${sdkPlatform}.platform
    sdkpath=$platformPath/Developer/SDKs
  '';
}
