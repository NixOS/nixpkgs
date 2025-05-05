{
  fetchgit,
  # unused for python module package because that provides all field sizes
  fieldSize ? 2048,
  lib,
  stdenv,
  useAssemblyBackendIfAvailable ? true,
  # `"c-library"` | `"python-module"`
  package ? "c-library",
  python3Packages,
}:
let
  filename = "libhighctidh_${toString fieldSize}.so";

  commonAttrs = finalAttrs: {
    version = "1.0.2024092800";

    src = fetchgit {
      url = "https://codeberg.org/vula/highctidh.git";
      rev = "v${finalAttrs.version}";
      hash = "sha256-UStNvXnaFLxL9aiMtxAKB8IbC0qnB6Pw+BObtG1XGKg=";
    };

    sourceRoot = "${finalAttrs.src.name}/src";

    env.${if useAssemblyBackendIfAvailable then null else "HIGHCTIDH_PORTABLE"} = "1";

    meta = with lib; {
      homepage = "https://codeberg.org/vula/highctidh";
      description = "high-ctidh fork as a portable shared library";
      maintainers = with maintainers; [ mightyiam ];
      license = licenses.publicDomain;
    };
  };

  impl = {
    c-library = stdenv.mkDerivation (
      finalAttrs:
      commonAttrs finalAttrs
      // {
        pname = "libhighctidh_${toString fieldSize}";

        buildFlags = [ filename ];

        doCheck = true;

        checkTarget = lib.concatStringsSep " " [
          "testrandom"
          "test${toString fieldSize}"
        ];

        installPhase = ''
          $preInstall

          mkdir -p $out/include/libhighctidh
          cp *.h $out/include/libhighctidh

          mkdir -p $out/lib
          cp ${filename} $out/lib

          $postInstall
        '';
      }
    );

    # Not using `buildPythonPackage` because want attr overrides and
    # https://github.com/NixOS/nixpkgs/issues/258246

    # Ideally, the python module would depend on the c library package,
    # but upstream claims that that is currently impossible:
    # > later, we can - but as of today, it isn't linking it as a library
    # > the python compiles a .so file (four) internally and uses ctypes to load it.
    # > This means it can work in a virtual environment regardless of the system library versions of highctidh installed.
    # > it's a bad idea but it surprisingly works ;)
    # So the python module builds all four library variants (four field sizes).
    python-module = stdenv.mkDerivation (
      finalAttrs:
      commonAttrs finalAttrs
      // {
        pname = "highctidh";

        pyproject = true;

        nativeBuildInputs = with python3Packages; [
          pypaBuildHook
          pythonImportsCheckHook
          pythonRemoveBinBytecodeHook
          setuptoolsBuildHook
          pipInstallHook
        ];

        nativeCheckInputs = [ python3Packages.pytestCheckHook ];
      }
    );
  };
in
impl.${package}
