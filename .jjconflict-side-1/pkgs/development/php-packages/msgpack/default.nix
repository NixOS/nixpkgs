{ buildPecl, lib }:

buildPecl rec {
  version = "2.2.0";
  pname = "msgpack";

  sha256 = "sha256-gqoeQExf9U7EHSogEwXNZZTtFKdSnpEZ+nykV+S70So=";

  meta = {
    changelog = "https://pecl.php.net/package-info.php?package=msgpack&version=${version}";
    description = "PHP extension for interfacing with MessagePack";
    homepage = "https://github.com/msgpack/msgpack-php";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.ostrolucky ];
  };
}
