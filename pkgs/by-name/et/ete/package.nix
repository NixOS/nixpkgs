{
  lib,
  stdenv,
  symlinkJoin,
  etlegacy-assets,
  ete-unwrapped,
  makeBinaryWrapper,
}:

symlinkJoin {
  pname = "ete";
  version = ete-unwrapped.version;

  paths = [
    (etlegacy-assets.overrideAttrs (prev: {
      postInstall = (prev.postInstall or "") + ''
        mv $out/lib/etlegacy $out/lib/ete
      '';
    }))
    ete-unwrapped
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/ete.* \
      --add-flags "+set fs_basepath ${placeholder "out"}/lib/ete"
    wrapProgram $out/bin/ete-ded.* \
      --add-flags "+set fs_basepath ${placeholder "out"}/lib/ete"
  '';

  meta = {
    description = "Improved Wolfenstein: Enemy Territory Engine";
    homepage = "https://github.com/etfdevs/ETe";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-nc-sa-30
    ];
    mainProgram = "ete." + (if stdenv.hostPlatform.isi686 then "x86" else "x86_64");
    maintainers = with lib.maintainers; [
      ashleyghooper
      drupol
    ];
    platforms = lib.platforms.linux;
  };
}
