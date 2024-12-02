{ lib
, stdenv
, buildGoModule
, rclone
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in buildGoModule rec {
  pname = "librclone";
  inherit (rclone) version src vendorHash;

  patches = rclone.patches or [ ];

  buildPhase = ''
    runHook preBuild
    cd librclone
    go build --buildmode=c-shared -o librclone${ext} github.com/rclone/rclone/librclone
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib librclone${ext}
    install -Dt $out/include librclone.h
    runHook postInstall
  '';

  meta = {
    description = "Rclone as a C library";
    homepage = "https://github.com/rclone/rclone/tree/master/librclone";
    maintainers = with lib.maintainers; [ dotlambda ];
    inherit (rclone.meta) license platforms;
  };
}
