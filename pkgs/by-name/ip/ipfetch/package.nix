{
  stdenv,
  lib,
  fetchFromGitHub,
  bash,
  wget,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "ipfetch";
  version = "0-unstable-2024-02-02";

  src = fetchFromGitHub {
    owner = "trakBan";
    repo = "ipfetch";
    rev = "09b61e0d1d316dbcfab798dd00bc3f9ceb02431d";
    sha256 = "sha256-RlbNIDRuf4sFS2zw4fIkTu0mB7xgJfPMDIk1I3UYXLk=";
  };

  strictDeps = true;
  buildInputs = [
    bash
    wget
  ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host ipfetch
    # Not only does `/usr` have to be replaced but also `/flags` needs to be added because with Nix the script is broken without this. The `/flags` is somehow not needed if you install via the install script in the source repository.
    substituteInPlace ./ipfetch --replace-fail /usr/share/ipfetch $out/usr/share/ipfetch/flags
  '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/usr/share/ipfetch/
    cp -r flags $out/usr/share/ipfetch/
    cp ipfetch $out/bin/ipfetch
    wrapProgram $out/bin/ipfetch --prefix PATH : ${
      lib.makeBinPath [
        bash
        wget
      ]
    }
  '';

  meta = with lib; {
    description = "Neofetch but for ip addresses";
    mainProgram = "ipfetch";
    homepage = "https://github.com/trakBan/ipfetch";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
