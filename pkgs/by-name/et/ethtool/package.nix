{
  lib,
  stdenv,
  fetchurl,
  libmnl,
  pkg-config,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ethtool";
  version = "7.0";

  src = fetchurl {
    url = "mirror://kernel/software/network/ethtool/ethtool-${finalAttrs.version}.tar.xz";
    hash = "sha256-Zgv5clp4cTQ6DSMgaKdjT7z7abbC+O/0VYJ/rvsM0WI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libmnl
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = writeScript "update-ethtool" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<a href="ethtool-VER.tar.xz">...</a>'
      # The page always lists versions newest to oldest. Pick the first one.
      new_version="$(curl -s https://mirrors.edge.kernel.org/pub/software/network/ethtool/ |
          pcregrep -o1 '<a href="ethtool-([0-9.]+)[.]tar[.]xz">' |
          head -n1)"
      update-source-version ethtool "$new_version"
    '';
  };

  meta = {
    description = "Utility for controlling network drivers and hardware";
    homepage = "https://www.kernel.org/pub/software/network/ethtool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bjornfor ];
    mainProgram = "ethtool";
  };
})
