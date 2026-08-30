{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxychains";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "haad";
    repo = "proxychains";
    rev = "proxychains-${finalAttrs.version}";
    sha256 = "083xdg6fsn8c2ns93lvy794rixxq8va6jdf99w1z0xi4j7f1nyjw";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/136093
    ./swap-priority-4-and-5-in-get_config_path.patch
  ];

  postPatch = ''
    # Suppress compiler warning. Remove it when upstream fix arrives
    substituteInPlace Makefile --replace "-Werror" "-Werror -Wno-stringop-truncation"
  '';

  installFlags = [
    "install-config"
  ];

  meta = {
    description = "Proxifier for SOCKS proxies";
    homepage = "https://proxychains.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
    mainProgram = "proxychains4";
  };
})
