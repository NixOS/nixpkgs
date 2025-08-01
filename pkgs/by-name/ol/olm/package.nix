{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.16";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = "olm";
    rev = version;
    sha256 = "sha256-JX20mpuLO+UoNc8iQlXEHAbH9sfblkBbM1gE27Ve0ac=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  postPatch = ''
    substituteInPlace olm.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  ''
  # Clang 19 has become more strict about assigning to const variables
  # Patch from https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=281497
  + lib.optionalString (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "19") ''
    substituteInPlace include/olm/list.hh \
      --replace-fail "T * const other_pos = other._data;" "T const * other_pos = other._data;"
  '';

  meta = with lib; {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      tilpner
      oxzi
    ];
    knownVulnerabilities = [
      ''
        The libolm end‐to‐end encryption library used in many Matrix
        clients and Jitsi Meet has been deprecated upstream, and relies
        on a cryptography library that has known side‐channel issues and
        disclaims that its implementations are not cryptographically secure
        and should not be used when cryptographic security is required.

        It is not known if the issues can be exploited over the network in
        practical conditions. Upstream does not believe such an attack is
        feasible, but has stated that the library should not be used going
        forward, and there are no plans to move to another cryptography
        implementation or otherwise further maintain the library at all.

        You should make an informed decision about whether to override this
        security warning, especially if you critically rely on end‐to‐end
        encryption. If you don’t care about that, or don’t use the Matrix
        functionality of a multi‐protocol client depending on libolm,
        then there should be no additional risk.

        Some clients are investigating migrating away from libolm to maintained
        libraries without known vulnerabilities.

        For further information, see:

        * The CVE records for the known vulnerabilities:

          * CVE-2024-45191
          * CVE-2024-45192
          * CVE-2024-45193

        * The libolm deprecation notice:
          <https://gitlab.matrix.org/matrix-org/olm/-/blob/6d4b5b07887821a95b144091c8497d09d377f985/README.md#important-libolm-is-now-deprecated>

        * The warning from the cryptography code used by libolm:
          <https://gitlab.matrix.org/matrix-org/olm/-/blob/6d4b5b07887821a95b144091c8497d09d377f985/lib/crypto-algorithms/README.md>

        * The blog post disclosing the details of the known vulnerabilities:
          <https://soatok.blog/2024/08/14/security-issues-in-matrixs-olm-library/>

        * The statement about the deprecation and vulnerabilities from the
          Matrix.org Foundation:
          <https://matrix.org/blog/2024/08/libolm-deprecation/>

        * A (likely incomplete) aggregation of client tracking issue links:
          <https://github.com/NixOS/nixpkgs/pull/334638#issuecomment-2289025802>
      ''
    ];
  };
}
