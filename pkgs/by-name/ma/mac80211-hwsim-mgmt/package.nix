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
  version = "unstable-2017-02-28";

  src = fetchFromGitHub {
    owner = "patgrosse";
    repo = "mac80211_hwsim_mgmt";
    rev = "d6a7e3bf683731805c761dbd56af11fb6d6c7e76";
    hash = "sha256-kVt+NtOKgep3Tnq4llkExM08Q09Nq90XEu06IOrrBMI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libevent
    libnl
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 hwsim_mgmt/hwsim_mgmt $out/bin/hwsim_mgmt
    runHook postInstall
  '';

  meta = {
    description = "Management tool for the mac80211_hwsim kernel module";
    homepage = "https://github.com/patgrosse/mac80211_hwsim_mgmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacka10086 ];
    mainProgram = "hwsim_mgmt";
    platforms = lib.platforms.linux;
  };
})
