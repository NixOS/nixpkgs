{
  fetchFromForgejo,
  installShellFiles,
  lib,
  libnotify,
  patchelf,
  rustPlatform,
  scdoc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hinoirisetr";
  version = "1.6.5";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.vavakado.xyz";
    owner = "me";
    repo = "hinoirisetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/76APHYDswc1rKIk9aiQcOOax+L0+2iuayqjqEMCBSU=";
  };

  cargoHash = "sha256-UX2Js2rrT6xBGe9CbgtqYF9F0tJdBYyiqjX5NpB09zc=";

  nativeBuildInputs = [
    installShellFiles
    patchelf
    scdoc
  ];

  buildInputs = [
    libnotify
  ];

  postFixup = ''
    patchelf --add-rpath "${lib.getLib libnotify}/lib" $out/bin/hinoirisetr
  '';

  postBuild = ''
    scdoc < manpages/hinoirisetr.1.sc > hinoirisetr.1
  '';

  postInstall = ''
    installManPage hinoirisetr.1
  '';

  meta = {
    description = "a lightweight daemon that automatically adjusts your screen's color temperature and gamma";
    homepage = "https://git.vavakado.xyz/me/hinoirisetr";
    changelog = "https://git.vavakado.xyz/me/hinoirisetr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vavakado
    ];
    mainProgram = "hinoirisetr";
    platforms = lib.platforms.linux;
  };
})
