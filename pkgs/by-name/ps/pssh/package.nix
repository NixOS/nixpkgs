{
  lib,
  fetchFromGitHub,
  python3Packages,
  openssh,
  rsync,
}:

python3Packages.buildPythonApplication rec {
  pname = "pssh";
  version = "2.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "pssh";
    tag = "v${version}";
    hash = "sha256-KG/7sHJn++eQ/tRT5pMeWDYxkf/Rk5q1x73fQoBdyx4=";
  };

  build-system = with python3Packages; [ setuptools ];

  postPatch = ''
    for f in bin/*; do
      substituteInPlace $f \
        --replace "'ssh'" "'${openssh}/bin/ssh'" \
        --replace "'scp'" "'${openssh}/bin/scp'" \
        --replace "'rsync'" "'${rsync}/bin/rsync'"
    done
  '';

  # Tests do not run with python3: https://github.com/lilydjwg/pssh/issues/126
  doCheck = false;

  meta = with lib; {
    description = "Parallel SSH Tools";
    longDescription = ''
      PSSH provides parallel versions of OpenSSH and related tools,
      including pssh, pscp, prsync, pnuke and pslurp.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/lilydjwg/pssh/blob/${src.tag}/ChangeLog";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];
  };
}
