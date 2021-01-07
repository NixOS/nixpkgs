{ stdenv, buildPythonApplication, fetchFromGitHub, callPackage
, mpv, python-mpv-jsonipc, jellyfin-apiclient-python
, pillow, tkinter, pystray, jinja2, pywebview }:

let
  shaderPack = callPackage ./shader-pack.nix {};
in
buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0alrh5h3f8pq9mrq09jmpqa0yslxsjqwij6kwn24ggbwc10zkq75";
    fetchSubmodules = true; # needed for display_mirror css file
  };

  patches = [
    ./disable-desktop-client.patch
    ./disable-update-check.patch
  ];

  # override $HOME directory:
  #   error: [Errno 13] Permission denied: '/homeless-shelter'
  #
  # remove jellyfin_mpv_shim/win_utils.py:
  #   ModuleNotFoundError: No module named 'win32gui'
  preCheck = ''
    export HOME=$TMPDIR

    rm jellyfin_mpv_shim/win_utils.py
  '';

  postPatch = ''
    # link the default shader pack
    ln -s ${shaderPack} jellyfin_mpv_shim/default_shader_pack
  '';

  propagatedBuildInputs = [
    jellyfin-apiclient-python
    mpv
    pillow
    python-mpv-jsonipc

    # gui dependencies
    pystray
    tkinter

    # display_mirror dependencies
    jinja2
    pywebview
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/iwalton3/jellyfin-mpv-shim";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
