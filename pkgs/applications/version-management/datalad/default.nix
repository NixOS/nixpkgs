{ lib, stdenv, fetchFromGitHub, installShellFiles, python3, git, git-annex }:

python3.pkgs.buildPythonApplication rec {
  pname = "datalad";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "datalad";
    repo = pname;
    rev = version;
    hash = "sha256-vqO37o5NxQk+gHfvhM1I2ea9/q9ZaLWkDEyPYJKEPcs";
  };

  nativeBuildInputs = [ installShellFiles git ];

  propagatedBuildInputs = with python3.pkgs; [
    # core
    platformdirs
    chardet
    iso8601
    humanize
    fasteners
    packaging
    patool
    tqdm
    annexremote
    looseversion
    setuptools
    git-annex

    # downloaders-extra
    # requests-ftp # not in nixpkgs yet

    # downloaders
    boto
    keyrings-alt
    keyring
    msgpack
    requests

    # publish
    python-gitlab

    # misc
    argcomplete
    pyperclip
    python-dateutil

    # metadata
    simplejson
    whoosh

    # metadata-extra
    pyyaml
    mutagen
    exifread
    python-xmp-toolkit
    pillow

    # duecredit
    duecredit

    # python>=3.8
    distro
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [ colorama ]
    ++ lib.optionals (python3.pythonOlder "3.10") [ importlib-metadata ];

  postInstall = ''
    installShellCompletion --cmd datalad \
         --bash <($out/bin/datalad shell-completion) \
         --zsh  <($out/bin/datalad shell-completion)
    wrapProgram $out/bin/datalad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "datalad" ];

  meta = with lib; {
    description = "Keep code, data, containers under control with git and git-annex";
    homepage = "https://www.datalad.org";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
