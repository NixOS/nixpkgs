{
  lib,
  callPackage,
  fetchFromGitHub,
  stdenv,
  wrapGAppsHook3,
}:
let
  pname = "easytier-gui";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "EasyTier";
    repo = "EasyTier";
    tag = "v${version}";
    hash = "sha256-F///8C7lyJZj5+u80nauDdrPFrEE40s0DeNzQeblImw=";
  };

  pnpm-hash = "sha256-eXMIa1EzS5E6nAYxQgq2G3J+diw+EFVGA+RKmdwQwFY=";
  vendor-hash = "sha256-f64tOU8AKC14tqX9Q3MLa7/pmIuI4FeFGOct8ZTAe+k=";

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      pnpm-hash
      vendor-hash
      meta
      ;
  };
  meta = {
    description = "EasyTier GUI based on tauri";
    homepage = "https://github.com/EasyTier/EasyTier";
    changelog = "https://github.com/EasyTier/EasyTier/releases/tag/v${version}";
    longDescription = ''
      EasyTier GUI based on tauri.
      EasyTier is a simple, safe and decentralized VPN networking solution implemented
      with the Rust language and Tokio framework.
    '';
    license = lib.licenses.asl20;
    mainProgram = "easytier-gui";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ initialencounter ];
  };
in
stdenv.mkDerivation {
  inherit
    pname
    src
    version
    meta
    ;

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r ${unwrapped}/share/* $out/share
    cp -r ${unwrapped}/bin/easytier-gui $out/bin/easytier-gui
    runHook postInstall
  '';
}
