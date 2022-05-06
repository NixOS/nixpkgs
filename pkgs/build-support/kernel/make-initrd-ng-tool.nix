{ rustPlatform, lib, makeWrapper, patchelf, glibc, binutils }:

rustPlatform.buildRustPackage {
  pname = "make-initrd-ng";
  version = "0.1.0";

  src = ./make-initrd-ng;
  cargoLock.lockFile = ./make-initrd-ng/Cargo.lock;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/make-initrd-ng \
      --prefix PATH : ${lib.makeBinPath [ patchelf glibc binutils ]}
  '';
}
