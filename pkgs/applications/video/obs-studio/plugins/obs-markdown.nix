{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation rec {
  pname = "obs-markdown";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-markdown";
    rev = version;
    sha256 = "sha256-5ajX/cEa0n12Putx1k3ctl1v9wRzJRhyJNDlmjSMbeU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio to add Markdown sources";
    homepage = "https://github.com/exeldro/obs-markdown";
    maintainers = with maintainers; [ flexiondotorg ];
    license = licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
  };
}
