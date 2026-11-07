{ stdenv
, lib
, fetchFromGitHub
, cmake
, withBoost ? true, boost ? null
}:

assert withBoost -> boost != null;

let
  version = "3.7.1";

in
stdenv.mkDerivation {
  pname = "fruit";
  inherit version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "fruit";
    rev = "v${version}";
    hash = "sha256-G1xlSKVUOYPEpbd/F7kTPPUUjnnb9TRYeQZyJjpbPIQ=";
  };

  nativeBuildInputs =
    [ cmake ]
    ++ lib.optional withBoost boost;

  cmakeFlags = [ (lib.cmakeBool "FRUIT_USES_BOOST" withBoost) ];
  enableParallelBuilding = true;
  enableParallelInstalling = true;

  meta = {
    homepage = "https://github.com/google/fruit";
    description = "Fruit, a dependency injection framework for C++";
    longDescription = ''
      Fruit is a dependency injection framework for C++, loosely inspired by the
      Guice framework for Java. It uses C++ metaprogramming together with some
      C++11 features to detect most injection problems at compile-time. It
      allows to split the implementation code in "components" (aka modules) that
      can be assembled to form other components. From a component with no
      requirements it's then possible to create an injector, that provides an
      instance of the interfaces exposed by the component.
    '';
    changelog = "https://github.com/google/fruit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tadfisher ];
    platforms = lib.platforms.all;
  };
}
