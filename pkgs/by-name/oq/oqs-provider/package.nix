{
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  liboqs,
  lib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "oqs-provider";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "oqs-provider";
    rev = finalAttrs.version;
    hash = "sha256-P3UEiWYchHVQ5s3JXHOzaDaN09K62pMYjnrW/gS5x/I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
    liboqs
  ];

  nativeCheckInputs = [ openssl.bin ];

  configureFlags = [ "--with-modulesdir=$$out/lib/ossl-modules" ];

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  preInstall = ''
    mkdir -p "$out"
    for dir in "$out" "${openssl.out}"; do
      mkdir -p .install/"$(dirname -- "$dir")"
      ln -s "$out" ".install/$dir"
    done
    export DESTDIR="$(realpath .install)"
  '';

  enableParallelInstalling = false;

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/open-quantum-safe/oqs-provider";
    description = "Open Quantum Safe provider for OpenSSL (3.x)";
    license = licenses.mit;
    maintainers = with maintainers; [ rixxc ];
    platforms = platforms.all;
  };
})
