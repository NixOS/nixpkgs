{
  stdenv,
  lib,
  fetchFromGitHub,
  wget,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "ipfetch";
  version = "0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "trakBan";
    repo = "ipfetch";
    rev = "a9cf53c17946fe1cfd786c5edf4cc88e903d80ce";
    hash = "sha256-EYGVDb8FY8aOSg7AD+2YuFI8BTr9QVGqmzpLHqUw5tI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs --host ipfetch-wget
    # The original script hard-coded "/usr/share/ipfetch/$flags", doing replace.
    substituteInPlace ./ipfetch-wget --replace-fail /usr/share/ipfetch $out/share/ipfetch/flags
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/ipfetch/
    cp -r flags $out/share/ipfetch/
    cp ipfetch-wget $out/bin/ipfetch
    wrapProgram $out/bin/ipfetch --prefix PATH : ${
      lib.makeBinPath [
        wget
      ]
    }
  '';

  meta = {
    description = "Neofetch but for ip addresses";
    mainProgram = "ipfetch";
    homepage = "https://github.com/trakBan/ipfetch";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      annaaurora
      VZstless
    ];
  };
}
