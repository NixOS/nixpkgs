find_package(PkgConfig REQUIRED)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_OSI_CLP REQUIRED IMPORTED_TARGET osi-clp)

  add_library(Coin::OsiClp ALIAS PkgConfig::PC_OSI_CLP)

  set(OsiClp_VERSION ${PC_OSI_CLP_VERSION})
endif()

find_path(OSI_CLP_INCLUDE_DIRS
          NAMES OsiSolverInterface.hpp
          HINTS ${PC_OSI_CLP_INCLUDE_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OsiClp
  REQUIRED_VARS OSI_CLP_INCLUDE_DIRS
  VERSION_VAR OsiClp_VERSION
	)

