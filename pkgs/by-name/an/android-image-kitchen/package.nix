{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
}:
stdenv.mkDerivation {
  pname = "android-image-kitchen";
  version = "0-unstable-2025-01-02";

  src = fetchFromGitHub {
    owner = "SebaUbuntu";
    repo = "AIK-Linux-mirror";
    rev = "b13ea8780b329250b5231b3c6476c61b692d95ec";
    hash = "sha256-AEZ+Dbp57s1As5lmnOZ5mJv1nXuTW9YJ1igNkyZGzmQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc
  ];

  postPatch = ''
    # We already take care of chmod in installPhase
    SUBST='chmod 644 "$bin/magic" "$bin/androidbootimg.magic" "$bin/androidsign.magic" "$bin/boot_signer.jar" "$bin/avb/"* "$bin/chromeos/"*;'
    substituteInPlace {cleanup,unpackimg}.sh \
      --replace-fail \
        'chmod -R 755 "$bin" "$aik"/*.sh;' "" \
      --replace-fail "$SUBST" ""
    substituteInPlace repackimg.sh \
      --replace-fail \
        'chmod -R 755 "$bin" "$aik/"*.sh;' "" \
      --replace-fail "$SUBST" ""
  '';

  installPhase =
    let
      genFindString =
        platform: arch:
        "find bin/${platform} -type d ! -name ${arch} ! -path bin/${platform} -exec rm -rf {} +";
      host = stdenv.hostPlatform;
    in
    # Remove unneeded binaries
    lib.concatStringsSep "\n" [
      "runHook preInstall"
      (
        if (host.isLinux && host.isAarch32) then
          (genFindString "linux" "ARM")
        else if (host.isLinux && host.isAarch64) then
          (genFindString "linux" "aarch64")
        else if (host.isLinux && host.isi686) then
          (genFindString "linux" "i686")
        else if (host.isLinux && host.isx86_64) then
          (genFindString "linux" "x86_64")
        else
          "rm -rf bin/linux"
      )
      (
        if (host.isDarwin && host.isx86_32) then
          (genFindString "macos" "i386")
        else if (host.isDarwin && host.isx86_64) then
          (genFindString "macos" "x86_64")
        else
          "rm -rf bin/macos"
      )
      "install -Dm 555 {cleanup,repackimg,unpackimg}.sh -t $out"
      "cp -r bin $out"
      "chmod -R 755 $out/bin/ $out/*.sh"
      "chmod 644 $out/bin/magic $out/bin/androidbootimg.magic $out/bin/androidsign.magic $out/bin/boot_signer.jar $out/bin/avb/* $out/bin/chromeos/*"
      "runHook postInstall"
    ];

  meta = {
    description = "Unpack & repack Android boot files";
    homepage = "https://github.com/SebaUbuntu/AIK-Linux-mirror";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
