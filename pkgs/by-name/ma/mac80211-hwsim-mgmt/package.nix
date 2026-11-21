{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libevent,
  libnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mac80211-hwsim-mgmt";
  version = "unstable-2020-03-11";

  # The upstream repository (patgrosse/mac80211_hwsim_mgmt) is unmaintained
  # since 2017; Mininet-WiFi maintains this fork and vendors it in its
  # installation script (util/install.sh).
  src = fetchFromGitHub {
    owner = "ramonfontes";
    repo = "mac80211_hwsim_mgmt";
    rev = "9d2cb2138bc41d1ee0227b4770aa8fc76f52fa13";
    hash = "sha256-sbE7Oas24YKN7JJPSqVa7iizxAIMrCQsL30simVdy1E=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libevent
    libnl
  ];

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 hwsim_mgmt/hwsim_mgmt $out/bin/hwsim_mgmt
    runHook postInstall
  '';

  meta = {
    description = "Management tool for the mac80211_hwsim kernel module";
    homepage = "https://github.com/ramonfontes/mac80211_hwsim_mgmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacka10086 ];
    mainProgram = "hwsim_mgmt";
    platforms = lib.platforms.linux;
  };
})
