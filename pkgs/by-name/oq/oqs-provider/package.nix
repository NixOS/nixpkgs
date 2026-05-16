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
  pname = "oqs-provider";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "oqs-provider";
    tag = finalAttrs.version;
    hash = "sha256-7nPYnlq6/GokWceHk1ZcnZo9A1z6LMtLBGM61zHvcyY=";
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

  meta = {
    homepage = "https://github.com/open-quantum-safe/oqs-provider";
    description = "Open Quantum Safe provider for OpenSSL (3.x)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rixxc ];
    platforms = lib.platforms.all;
  };
})
