{ stdenv, buildPackages, callPackage }:

let
  chezArch =
    /**/ if stdenv.hostPlatform.isAarch then "arm${toString stdenv.hostPlatform.parsed.cpu.bits}"
    else if stdenv.hostPlatform.isx86_32 then "i3"
    else if stdenv.hostPlatform.isx86_64 then "a6"
    else if stdenv.hostPlatform.isPower then "ppc${toString stdenv.hostPlatform.parsed.cpu.bits}"
    else throw "Add ${stdenv.hostPlatform.parsed.cpu.arch} to chezArch to enable building chez-racket";

  chezOs =
    /**/ if stdenv.hostPlatform.isDarwin then "osx"
    else if stdenv.hostPlatform.isFreeBSD then "fb"
    else if stdenv.hostPlatform.isLinux then "le"
    else if stdenv.hostPlatform.isNetBSD then "nb"
    else if stdenv.hostPlatform.isOpenBSD then "ob"
    else throw "Add ${stdenv.hostPlatform.uname.system} to chezOs to enable building chez-racket";

  inherit (stdenv.hostPlatform) system;
  chezSystem = "t${chezArch}${chezOs}";
  # Chez Scheme uses an ad-hoc `configure`, hence we don't use the usual
  # stdenv abstractions.
  forBoot = {
    pname = "chez-scheme-racket-boot";
    configurePhase = ''
      runHook preConfigure
      ./configure --pb ZLIB=$ZLIB LZ4=$LZ4
      runHook postConfigure
    '';
    makeFlags = [ "${chezSystem}.bootquick" ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      pushd boot
      mv $(ls -1 | grep -v "^pb$") -t $out
      popd
      runHook postInstall
    '';
  };
  boot = buildPackages.callPackage (import ./shared.nix forBoot) {};
  forFinal = {
    pname = "chez-scheme-racket";
    configurePhase = ''
      runHook preConfigure
      cp -r ${boot}/* -t ./boot
      ./configure -m=${chezSystem} --installprefix=$out --installman=$out/share/man ZLIB=$ZLIB LZ4=$LZ4
      runHook postConfigure
    '';
    preBuild = ''
      pushd ${chezSystem}/c
    '';
    postBuild = ''
      popd
    '';
    setupHook = ./setup-hook.sh;
  };
  final = callPackage (import ./shared.nix forFinal) {};
in
final
