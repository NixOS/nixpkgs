{ cmake
, fetchFromGitea
, lib
, nlohmann_json
, qt6
, stdenv
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.0";
  pname = "swaymux";

  src = fetchFromGitea {
    rev = "v${finalAttrs.version}";
    domain = "git.grimmauld.de";
    owner = "Grimmauld";
    repo = "swaymux";
    hash = "sha256-M85pqfYnYeVPTZXKtjg/ks5LUl3u2onG9Nfn8Xs+BSA=";
  };

  buildInputs = [ qt6.qtwayland nlohmann_json qt6.qtbase];
  nativeBuildInputs = [ cmake qt6.wrapQtAppsHook ];

  doCheck = true;

  meta = with lib; {
    changelog = "https://git.grimmauld.de/Grimmauld/swaymux/commits/branch/main";
    description = "A program to quickly navigate sway";
    homepage = "https://git.grimmauld.de/Grimmauld/swaymux";
    license = licenses.bsd3;
    longDescription = ''
      Swaymux allows the user to quickly navigate and administrate outputs, workspaces and containers in a tmux-style approach.
    '';
    mainProgram = "swaymux";
    maintainers = with maintainers; [ grimmauld ];
    platforms = platforms.linux;
  };
})
