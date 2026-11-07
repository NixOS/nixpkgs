{
  stdenv,
  lib,
  nixos-container,
  openssh,
  glibcLocales,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "extra-container";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "extra-container";
    repo = "extra-container";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fLE3qALPTc9audJ/r1IXMd8eva4mpTYyKW50iJJcDxA=";
  };

  buildCommand = ''
    install -D $src/extra-container $out/bin/extra-container
    patchShebangs $out/bin
    share=$out/share/extra-container
    install $src/eval-config.nix -Dt $share

    # Use existing PATH for systemctl and machinectl
    scriptPath="export PATH=${lib.makeBinPath [ openssh ]}:\$PATH"

    sed -i "
      s|evalConfig=.*|evalConfig=$share/eval-config.nix|
      s|LOCALE_ARCHIVE=.*|LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive|
      2i$scriptPath
      2inixosContainer=${nixos-container}/bin
    " $out/bin/extra-container
  '';

  meta = {
    description = "Run declarative containers without full system rebuilds";
    homepage = "https://github.com/extra-container/extra-container";
    changelog = "https://github.com/extra-container/extra-container/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.stevelr ];
    mainProgram = "extra-container";
  };
})
