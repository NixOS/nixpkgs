{
  lib,
  fetchFromGitHub,
  python3,
  replaceVars,
  fetchpatch,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "recon-ng";
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lanmaster53";
    repo = "recon-ng";
    tag = "v${version}";
    hash = "sha256-W7pL4Rl86i881V53SAwECAMp2Qj/azPM3mdvxvt+gjc=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    pyyaml
    dnspython
    lxml
    mechanize
    requests
    flask
    flask-restful
    flasgger
    dicttoxml
    xlsxwriter
    unicodecsv
    rq
  ];

  patches = [
    # Support python 3.12
    # https://github.com/lanmaster53/recon-ng/pull/218
    # This is merged and can be removed when updating
    (fetchpatch {
      name = "fix_python12.patch";
      url = "https://github.com/lanmaster53/recon-ng/commit/e31c30e5c314cbc5e57a13f9d3ddf29afafc4cb3.patch";
      hash = "sha256-e8BTRkwb42mTTwivZ0sTxVw1hnYCUVInmy91jyVc/tw=";
    })
  ];

  postPatch =
    let
      setup = replaceVars ./setup.py {
        inherit pname version;
      };
    in
    ''
      ln -s ${setup} setup.py
    '';

  postInstall = ''
    cp VERSION $out/${python3.sitePackages}/
    cp -R recon/core/web/{definitions.yaml,static,templates} $out/${python3.sitePackages}/recon/core/web/
  '';

  meta = {
    description = "Full-featured framework providing a powerful environment to conduct web-based reconnaissance";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/lanmaster53/recon-ng/";
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
