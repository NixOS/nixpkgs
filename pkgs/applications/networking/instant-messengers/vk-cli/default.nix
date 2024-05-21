{ stdenv
, lib
, fetchurl
, curl
, p7zip
, glibc
, ncurses
, openssl
}:

stdenv.mkDerivation rec {
  pname = "vk-cli";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/vk-cli/vk/releases/download/${version}/vk-${version}-64-bin.7z";
    sha256 = "sha256-Y40oLjddunrd7ZF1JbCcgjSCn8jFTubq69jhAVxInXw=";
  };

  nativeBuildInputs = [
    p7zip
  ];

  buildInputs = [
    curl
    ncurses
    openssl
  ];

  unpackPhase = ''
    mkdir -p $TMP/
    7z x $src -o$TMP/
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mv $TMP/vk-${version}-64-bin vk-cli
    install -D vk-cli --target-directory=$out/bin/
  '';

  postFixup = ''
    patchelf $out/bin/vk-cli \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ curl glibc ]}"
  '';

  meta = with lib; {
    description = "A console (ncurses) client for vk.com written in D";
    mainProgram = "vk-cli";
    homepage = "https://github.com/vk-cli/vk";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
  };
}
