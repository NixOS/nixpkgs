{ lib, buildNpmPackage, fetchFromGitHub }:

let
  pname = "logpipe";
  version = "0.0.5";

  packageLock =
  let
    name = "@emnudge/logpipe";
  in
  {
    inherit version name;
    lockfileVersion = 3;
    requires = true;
    packages= {
      "\"\"" = {
        inherit version name;
        license = "MIT";
        bin = {
          "${pname}" = "index.mjs";
        };
      };
    };
  };
in
buildNpmPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "EmNudge";
    repo = pname;
    rev = "af21baaca4d4779479c9307e9b844cafdb4507f2";
    hash = "sha256-0/8um5HaiGfGd0hfproUDZklbCxcxImlPzFQx7VpvzM=";
  };

  # We have no deps, but no lockfile exists upstream. Fudge an empty one.
  npmDepsHash = "sha256-1ZRmgKrlPQEGDqmqEq9DEg7fowT8dIIZ4xSHTKHdBGg=";
  postPatch = ''
    echo '${builtins.toJSON packageLock}' > package-lock.json
    mkdir node_modules
  '';
  forceEmptyCache = true;

  # dontNpmInstall = true;
  dontNpmBuild = true;

  meta = with lib; {
    description = "Inspect your logs";
    homepage = "https://logpipe.emnudge.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ nullishamy ];
    mainProgram = "logpipe";
  };
}
