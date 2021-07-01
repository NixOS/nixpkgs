{ stdenv
, lib
, fetchurl
, curlFull
, zulip
, p7zip
, glibc
, ncurses
, openssl
}:

stdenv.mkDerivation rec {
  pname = "vk-cli";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/vk-cli/vk/releases/download/${version}/vk-0.7.6-64-bin.7z";
    sha256 = "sha256-Y40oLjddunrd7ZF1JbCcgjSCn8jFTubq69jhAVxInXw=";
  };

  nativeBuildInputs = [
    p7zip
  ];

  buildInputs = [
    curlFull
    ncurses
    openssl
  ];

  unpackPhase = ''
    mkdir -p $TMP/
    7z x $src -o$TMP/
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mv $TMP/vk-0.7.6-64-bin vk-cli
    install -D vk-cli --target-directory=$out/bin/
  '';

  postFixup = let
    libPath = lib.makeLibraryPath [
      curlFull
      zulip
      glibc
    ];
  in ''
    patchelf \
    --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    --set-rpath "${libPath}" \
    $out/bin/vk-cli
    '';

  meta = with lib; {
    description = "A console (ncurses) client for vk.com written in D";
    license = licenses.asl20;
    maintainers = with maintainers; [ dan4ik605743 ];
    homepage = "https://github.com/vk-cli/vk";
  };
}
