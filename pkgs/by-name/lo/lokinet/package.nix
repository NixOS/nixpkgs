{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libevent,
  libsodium,
  libuv,
  nlohmann_json,
  pkg-config,
  spdlog,
  sqlite,
  systemd,
  unbound,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "lokinet";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "oxen-io";
    repo = "lokinet";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Gmc3h3J19tn2UMvhHApoKsUwbBnudmkLA+9EhC1NDqs=";
  };

  patches = [
    # Fix gcc-13 compatibility:
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/oxen-io/lokinet/commit/89c5c73be48788ba14a55cb6d82d57208b487eaf.patch";
      hash = "sha256-yCy4WXs6p67TMe4uPNAuQyJvtP3IbpJS81AeomNu9lU=";
    })
  ];

  postPatch = ''
        # Fix fmt compatibility: format() must be const in custom formatters
        substituteInPlace llarp/util/aligned.hpp \
          --replace-fail 'FormatContext& ctx)' 'FormatContext& ctx) const'

        substituteInPlace external/oxen-mq/oxenmq/fmt.h \
          --replace-fail 'format_context& ctx)' 'format_context& ctx) const'

        substituteInPlace external/oxen-logging/include/oxen/log/color.hpp \
          --replace-fail 'FormatContext& ctx)' 'FormatContext& ctx) const'

        # Fix spdlog/fmt compatibility by avoiding fmt/ranges.h and its conflict with AlignedBuffer.

        substituteInPlace llarp/util/str.hpp \
          --replace-fail 'return fmt::format("{}", fmt::join(delimiter, begin, end));' \
                         'std::string s; for (auto it = begin; it != end; ++it) { if (it != begin) s += delimiter; s += fmt::format("{}", *it); } return s;'

        substituteInPlace llarp/net/interface_info.cpp \
          --replace-fail '#include "interface_info.hpp"' '#include "interface_info.hpp"
    #include <llarp/util/str.hpp>' \
          --replace-fail 'fmt::join(addrs, ",")' 'llarp::join(",", addrs)'

        substituteInPlace llarp/service/intro_set.cpp \
          --replace-fail '#include "intro_set.hpp"' '#include "intro_set.hpp"
    #include <llarp/util/str.hpp>' \
          --replace-fail 'fmt::join(intros, ",")' 'llarp::join(",", intros)'

        substituteInPlace llarp/router_contact.cpp \
          --replace-fail '#include "router_contact.hpp"' '#include "router_contact.hpp"
    #include <llarp/util/str.hpp>' \
          --replace-fail 'fmt::join(addrs, ",")' 'llarp::join(",", addrs)'

        substituteInPlace llarp/dns/message.cpp \
          --replace-fail '#include "message.hpp"' '#include "message.hpp"
    #include <llarp/util/str.hpp>' \
          --replace-fail 'fmt::join(questions, ",")' 'llarp::join(",", questions)' \
          --replace-fail 'fmt::join(answers, ",")' 'llarp::join(",", answers)' \
          --replace-fail 'fmt::join(authorities, ",")' 'llarp::join(",", authorities)' \
          --replace-fail 'fmt::join(additional, ",")' 'llarp::join(",", additional)'

        substituteInPlace llarp/router/router.cpp \
          --replace-fail 'fmt::format_to(out, "v{}", fmt::join(llarp::VERSION, "."));' \
                         'fmt::format_to(out, "v{}.{}.{}", llarp::VERSION[0], llarp::VERSION[1], llarp::VERSION[2]);'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libevent
    libuv
    libsodium
    nlohmann_json
    spdlog
    sqlite
    systemd
    unbound
    zeromq
  ];

  cmakeFlags = [
    "-DGIT_VERSION=v${version}"
    "-DWITH_BOOTSTRAP=OFF" # we provide bootstrap files manually
    "-DWITH_SETCAP=OFF"
  ];

  meta = {
    description = "Anonymous, decentralized and IP based overlay network for the internet";
    homepage = "https://lokinet.org/";
    changelog = "https://github.com/oxen-io/lokinet/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wyndon ];
  };
}
