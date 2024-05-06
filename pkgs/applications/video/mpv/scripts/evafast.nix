{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "evafast";
  version = "0-unstable-2022-09-11";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "evafast";
    rev = "f9ee7e41dedf0f65186900e0ccdd6ca6a8ced7ed";
    hash = "sha256-+hJffVI0eu861N9f0Jg4B+53It0x31qOYVB1agMjFIw=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Seeking and hybrid fastforwarding like VHS";
    homepage = "https://github.com/po5/evafast";
    license = licenses.unfree; # no license; see https://github.com/po5/evafast/issues/15
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}
