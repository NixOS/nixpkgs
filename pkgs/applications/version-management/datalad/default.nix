{ lib, stdenv, fetchFromGitHub, installShellFiles, python3, git }:

python3.pkgs.buildPythonApplication rec {
  pname = "datalad";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "datalad";
    repo = pname;
    rev = version;
    hash = "sha256-6uWOKsYeNZJ64WqoGHL7AsoK4iZd24TQOJ1ECw+K28Y=";
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
  ] ++ lib.optional stdenv.hostPlatform.isWindows [ colorama ]
    ++ lib.optional (python3.pythonOlder "3.10") [ importlib-metadata ];

  postInstall = ''
    installShellCompletion --cmd datalad \
         --bash <($out/bin/datalad shell-completion) \
         --zsh  <($out/bin/datalad shell-completion)
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Keep code, data, containers under control with git and git-annex";
    homepage = "https://www.datalad.org";
    license = licenses.mit;
    maintainers = with maintainers; [ renesat ];
  };
}
