{ stdenv
, fetchurl
, autoPatchelfHook
, installShellFiles
, makeWrapper
, jre
, lib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "bleep";
  version = "0.0.5";

  platform =
    if stdenv.isLinux && stdenv.isx86_64 then "x86_64-pc-linux"
    else if stdenv.isDarwin && stdenv.isx86_64 then "x86_64-apple-darwin"
    else if stdenv.isDarwin && stdenv.isAarch64 then "arm64-apple-darwin"
    else throw "unsupported platform";

  src = fetchurl {
    url = "https://github.com/oyvindberg/bleep/releases/download/v${version}/bleep-${platform}.tar.gz";
    sha256 =
      if stdenv.isLinux && stdenv.isx86_64 then "sha256-oNowRH92i76Ubbn07fLBzzX2X9Xez1ByZ/va4+vMdP0="
      else if stdenv.isDarwin && stdenv.isx86_64 then "sha256-XvgD7Y02hWUEJyTscQ3orOREv5pB78tTIJq0EEGVeN4="
      else if stdenv.isDarwin && stdenv.isAarch64 then "sha256-aGXNKUcbuaz1GJIJfVU8B3YJKC24EtX7hgsEOoXKBwo="
    else throw "unsupported platform";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook;

  buildInputs = [ zlib stdenv.cc.cc ];

  unpackPhase = ''
    runHook preUnpack
    tar -xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bleep $out/bin/.bleep-wrapped
    makeWrapper $out/bin/.bleep-wrapped $out/bin/bleep \
      --argv0 "$out/bin/bleep"
    runHook postInstall
  '';

  dontAutoPatchelf = true;

  postFixup = lib.optionalString stdenv.isLinux ''
    autoPatchelf $out
  '' + ''
    mkdir temp
    cp $out/bin/.bleep-wrapped temp/bleep
    PATH="./temp:$PATH"

    installShellCompletion --cmd bleep \
      --bash <(bleep install-tab-completions-bash --stdout) \
      --zsh <(bleep install-tab-completions-zsh --stdout) \
  '';

  meta = with lib; {
    homepage = "https://bleep.build/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    description = "Bleeping fast scala build tool";
    mainProgram = "bleep";
    platforms = [ "x86_64-linux" "x86_64-apple-darwin" "arm64-apple-darwin" ];
    maintainers = with maintainers; [ kristianan ];
  };
}
