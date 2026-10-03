{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "perfect-hash";
  version = "0.4.1";
  pyproject = true;

  # Archive on pypi does not contain examples, which are very helpful to
  # understand how to use this program, so we use git source.
  src = fetchFromGitHub {
    owner = "ilanschnell";
    repo = "perfect-hash";
    rev = finalAttrs.version;
    hash = "sha256-Ip2DU4wetbSyelImbMY9SZpkQ7UCZjslwYDCEYwdbD4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  postInstall = ''
    mkdir -p $out/share/doc/perfect-hash
    cp README.md $out/share/doc/perfect-hash
    cp -r examples $out/share/doc/perfect-hash
  '';

  meta = {
    description = "Minimal perfect hash function generator";
    mainProgram = "perfect-hash";
    longDescription = ''
      Generate a minimal perfect hash function for a given set of keys.
      A given code template is filled with parameters, such that the
      output is code which implements the hash function. Templates can
      easily be constructed for any programming language.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.kaction ];

    homepage = "https://github.com/ilanschnell/perfect-hash";
    platforms = lib.platforms.unix;
  };
})
