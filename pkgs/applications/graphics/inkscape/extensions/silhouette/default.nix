{ fetchFromGitHub
, lib
, gettext
, pkgs
, python3
, umockdev
, writeScript
}:

let
  # We need these simple wrapper shell scripts because Inkscape extensions with
  # interpreter="shell" always get invoked with the `sh` command [0], regardless of
  # the shebang at the top of the script.
  # [0]: https://gitlab.com/inkscape/inkscape/-/blob/d61d917afb94721c92a650b2c4b116b0a4826f41/src/extension/implementation/script.cpp#L93
  launch-sendto_silhouette = writeScript "sendto_silhouette.sh" ''
    cd $(dirname $0)
    ./sendto_silhouette.py "$@"
  '';
  launch-silhouette_multi = writeScript "silhouette_multi.sh" ''
    cd $(dirname $0)
    ./silhouette_multi.py "$@"
  '';
in
python3.pkgs.buildPythonApplication rec {
  pname = "inkscape-silhouette";
  version = "1.28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fablabnbg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uNVhdkZFadL7QNlCsXq51TbhzRKH9KYDPDNCFhw3cQs=";
  };

  patches = [
    ./interpreter.patch
    ./use-prefix-for-udev.patch
  ];

  propagatedBuildInputs = [
    python3.pkgs.pyusb
    python3.pkgs.lxml
    python3.pkgs.inkex
    python3.pkgs.matplotlib
    python3.pkgs.wxpython
    python3.pkgs.xmltodict
  ];

  nativeBuildInputs = [
    gettext # msgfmt
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    umockdev
  ];

  pytestFlagsArray = [
    "test"
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall
    make install PREFIX=$out
    runHook postInstall
  '';

  postInstall = ''
    # Unmark read_dump.py as executable so wrapPythonProgramsIn won't turn it
    # into a shell script (thereby making it impossible to import as a Python
    # module).
    chmod -x $out/share/inkscape/extensions/silhouette/read_dump.py
    cp ${launch-sendto_silhouette} $out/share/inkscape/extensions/sendto_silhouette.sh
    cp ${launch-silhouette_multi} $out/share/inkscape/extensions/silhouette_multi.sh
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/inkscape/extensions/" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "An extension to drive Silhouette vinyl cutters (e.g. Cameo, Portrait, Curio series) from within Inkscape";
    homepage = "https://github.com/fablabnbg/inkscape-silhouette";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jfly ];
    platforms = platforms.all;
  };
}
