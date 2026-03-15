{ stdenv, lib }:
stdenv.mkDerivation {
  name = "nix-user-chroot";
  src = ./src;

  buildInputs = [
    stdenv.cc.cc.libgcc or null
  ];

  makeFlags = [ ];

  # hack to use when /nix/store is not available
  postFixup = ''
    exe=$out/bin/nix-user-chroot
    patchelf \
      --set-interpreter .$(patchelf --print-interpreter $exe) \
      --set-rpath $(patchelf --print-rpath $exe | sed 's|/nix/store/|./nix/store/|g') \
      $exe
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp nix-user-chroot $out/bin/nix-user-chroot

    runHook postInstall
  '';

  meta = {
    description = "<TODO add desc>";
    homepage = "https://github.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      artturin
      tomberek
      eveeifyeve
    ];
    platforms = lib.platforms.linux;
  };
}
