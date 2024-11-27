{ stdenv, lib
, fetchFromGitHub
, python3
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "btrfs-heatmap";
  version = "9";

  src = fetchFromGitHub {
    owner = "knorrie";
    repo = "btrfs-heatmap";
    rev = "v${version}";
    sha256 = "sha256-yCkuZqWwxrs2eS7EXY6pAOVVVSq7dAMxJtf581gX8vg=";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.wrapPython installShellFiles ];

  outputs = [ "out" "man" ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 btrfs-heatmap $out/sbin/btrfs-heatmap
    installManPage man/btrfs-heatmap.1

    buildPythonPath ${python3.pkgs.btrfs}
    patchPythonScript $out/sbin/btrfs-heatmap

    runHook postInstall
  '';

  meta = with lib; {
    description = "Visualize the layout of a mounted btrfs";
    mainProgram = "btrfs-heatmap";
    homepage = "https://github.com/knorrie/btrfs-heatmap";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.evils ];
  };
}
