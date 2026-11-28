{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  python3,
  brother-pe-core,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brother-pe-cli";
  version = "0.4.2";

  src = fetchFromGitLab {
    owner = "dlarochette";
    repo = "brother-pe-cli";
    tag = finalAttrs.version;
    hash = "sha256-63VoIzoQgTS8sa92slIJXIhr3FleHip4rpiWFlRxfi0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ brother-pe-core ];

  postPatch = ''
    patchShebangs --build tests
  '';

  # The thumbnailer daemon does not necessarily have the command in its PATH.
  postInstall = ''
    substituteInPlace $out/share/thumbnailers/brother-pe.thumbnailer \
      --replace-fail "TryExec=brother-pe" "TryExec=$out/bin/brother-pe" \
      --replace-fail "Exec=brother-pe " "Exec=$out/bin/brother-pe "
  '';

  doCheck = true;

  nativeCheckInputs = [ python3 ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for Brother embroidery cards and designs";
    longDescription = ''
      The brother-pe command drives the Brother USB embroidery card writer
      (04f9:2100): read, back up, restore, compose and write Brother embroidery
      memory cards. It also converts designs between PES, PEC, DST, EXP, JEF,
      VP3, XXX and G-code, streams G-code to GRBL or Marlin embroidery machines
      and provides a freedesktop thumbnailer for these formats. On NixOS, add
      brother-pe-core to services.udev.packages for access to the reader.
    '';
    homepage = "https://gitlab.com/dlarochette/brother-pe-cli";
    changelog = "https://gitlab.com/dlarochette/brother-pe-cli/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dlarochette ];
    mainProgram = "brother-pe";
    platforms = lib.platforms.linux;
  };
})
