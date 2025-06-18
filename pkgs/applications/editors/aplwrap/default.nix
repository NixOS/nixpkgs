{ stdenv
, lib
, autoreconfHook
, fetchFromGitHub
, gnuapl
, gsettings-desktop-schemas
, gtk3
, makeWrapper
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "aplwrap";
  version = "2.4";

  srcs = [
    (fetchFromGitHub {
      owner = "ChrisMoller";
      repo = "aplwrap";
      rev = "773228a8107a0850bf0589cda234cb538b163818";
      hash = "sha256-gvajdcU+ZXe5X9S/jnU5C8tkE9yFBd3g7JF4UQttgCk=";
    })
    # aplwrap requires gnuapl sources to compile
    gnuapl.src
  ];

  # Because we have multple sources, we need to tell nix where
  # the build should be based out of
  sourceRoot = "source";

  # Do not make this target since all it does is to run fc-cache,
  # which we don't need and also leads to errors.
  preConfigurePhases = [ "removeInstallDataHook" ];
  removeInstallDataHook = ''
    substituteInPlace Makefile.am \
      --replace 'fc-cache' 'echo skipping fc-cache'
  '';

  preBuildPhases = [ "patchBuildInfo" ];
  patchBuildInfo = ''
    patchShebangs src/buildinfo
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config makeWrapper ];
  buildInputs = [ gnuapl gtk3 gsettings-desktop-schemas ];

  # Because aplwrap starts the apl binary using "apl", we need to add gnuapl
  # to path in the context of aplwrap
  # We need to set XDG_DATA_DIRS the error
  # 'No GSettings schemas are installed on the system' when changing settings
  postInstall = ''
    wrapProgram "$out/bin/aplwrap" \
      --suffix XDG_DATA_DIRS ':' "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --suffix PATH ':' "${gnuapl}/bin"
  '';

  meta = {
    description = "A GTK+-based wrapper for GNU APL";
    homepage = "https://github.com/ChrisMoller/aplwrap";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wchresta ];
  };
}
