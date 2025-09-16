{
  stdenv,
  lib,
  nixos-container,
  openssh,
  glibcLocales,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "extra-container";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "erikarvstedt";
    repo = "extra-container";
    rev = version;
    hash = "sha256-vgh3TqfkFdnPxREBedw4MQehIDc3N8YyxBOB45n+AvU=";
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
    homepage = "https://github.com/erikarvstedt/extra-container";
    changelog = "https://github.com/erikarvstedt/extra-container/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.erikarvstedt ];
    mainProgram = "extra-container";
  };
}
