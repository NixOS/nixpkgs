let

  lib = import ./default.nix;

  spdx = lic: lic // {
    url = "http://spdx.org/licenses/${lic.spdxId}";
  };

in

lib.mapAttrs (n: v: v // { shortName = n; }) rec {
  /* License identifiers from spdx.org where possible.
   * If you cannot find your license here, then look for a similar license or
   * add it to this list. The URL mentioned above is a good source for inspiration.
   */

  afl21 = spdx {
    spdxId = "AFL-2.1";
    fullName = "Academic Free License";
  };

  agpl3 = spdx {
    spdxId = "AGPL-3.0";
    fullName = "GNU Affero General Public License v3.0";
  };

  agpl3Plus = {
    fullName = "GNU Affero General Public License v3.0 or later";
    inherit (agpl3) url;
  };

  amazonsl = {
    fullName = "Amazon Software License";
    url = http://aws.amazon.com/asl/;
    free = false;
  };

  amd = {
    fullName = "AMD License Agreement";
    url = http://developer.amd.com/amd-license-agreement/;
  };

  apsl20 = spdx {
    spdxId = "APSL-2.0";
    fullName = "Apple Public Source License 2.0";
  };

  artistic1 = spdx {
    spdxId = "Artistic-1.0";
    fullName = "Artistic License 1.0";
  };

  artistic2 = spdx {
    spdxId = "Artistic-2.0";
    fullName = "Artistic License 2.0";
  };

  asl20 = spdx {
    spdxId = "Apache-2.0";
    fullName = "Apache License 2.0";
  };

  boost = spdx {
    spdxId = "BSL-1.0";
    fullName = "Boost Software License 1.0";
  };

  bsd2 = spdx {
    spdxId = "BSD-2-Clause";
    fullName = ''BSD 2-clause "Simplified" License'';
  };

  bsd3 = spdx {
    spdxId = "BSD-3-Clause";
    fullName = ''BSD 3-clause "New" or "Revised" License'';
  };

  bsdOriginal = spdx {
    spdxId = "BSD-4-Clause";
    fullName = ''BSD 4-clause "Original" or "Old" License'';
  };

  cc0 = spdx {
    spdxId = "CC0-1.0";
    fullName = "Creative Commons Zero v1.0 Universal";
  };

  cc-by-30 = spdx {
    spdxId = "CC-BY-3.0";
    fullName = "Creative Commons Attribution 3.0";
  };

  cc-by-sa-30 = spdx {
    spdxId = "CC-BY-SA-3.0";
    fullName = "Creative Commons Attribution Share Alike 3.0";
  };

  cc-by-40 = spdx {
    spdxId = "CC-BY-4.0";
    fullName = "Creative Commons Attribution 4.0";
  };

  cddl = spdx {
    spdxId = "CDDL-1.0";
    fullName = "Common Development and Distribution License 1.0";
  };

  cecill20 = spdx {
    spdxId = "CECILL-2.0";
    fullName = "CeCILL Free Software License Agreement v2.0";
  };

  cecill-b = spdx {
    spdxId = "CECILL-B";
    fullName  = "CeCILL-B Free Software License Agreement";
  };

  cecill-c = spdx {
    spdxId = "CECILL-C";
    fullName  = "CeCILL-C Free Software License Agreement";
  };

  cpl10 = spdx {
    spdxId = "CPL-1.0";
    fullName = "Common Public License 1.0";
  };

  epl10 = spdx {
    spdxId = "EPL-1.0";
    fullName = "Eclipse Public License 1.0";
  };

  free = {
    fullName = "Unspecified free software license";
  };

  gpl1 = spdx {
    spdxId = "GPL-1.0";
    fullName = "GNU General Public License v1.0 only";
  };

  gpl1Plus = spdx {
    spdxId = "GPL-1.0+";
    fullName = "GNU General Public License v1.0 or later";
  };

  gpl2 = spdx {
    spdxId = "GPL-2.0";
    fullName = "GNU General Public License v2.0 only";
  };

  gpl2ClasspathPlus = {
    fullName = "GNU General Public License v2.0 or later (with Classpath exception)";
    url = https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception;
  };

  gpl2Oss = {
    fullName = "GNU General Public License version 2 only (with OSI approved licenses linking exception)";
    url = http://www.mysql.com/about/legal/licensing/foss-exception;
  };

  gpl2Plus = spdx {
    spdxId = "GPL-2.0+";
    fullName = "GNU General Public License v2.0 or later";
  };

  gpl3 = spdx {
    spdxId = "GPL-3.0";
    fullName = "GNU General Public License v3.0 only";
  };

  gpl3Plus = spdx {
    spdxId = "GPL-3.0+";
    fullName = "GNU General Public License v3.0 or later";
  };

  gpl3ClasspathPlus = {
    fullName = "GNU General Public License v3.0 or later (with Classpath exception)";
    url = https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception;
  };

  # Intel's license, seems free
  iasl = {
    fullName = "iASL";
    url = http://www.calculate-linux.org/packages/licenses/iASL;
  };

  inria = {
    fullName  = "INRIA Non-Commercial License Agreement";
    url       = "http://compcert.inria.fr/doc/LICENSE";
  };

  ipa = spdx {
    spdxId = "IPA";
    fullName = "IPA Font License";
  };

  ipl10 = spdx {
    spdxId = "IPL-1.0";
    fullName = "IBM Public License v1.0";
  };

  isc = spdx {
    spdxId = "ISC";
    fullName = "ISC License";
  };

  lgpl2 = spdx {
    spdxId = "LGPL-2.0";
    fullName = "GNU Library General Public License v2 only";
  };

  lgpl2Plus = spdx {
    spdxId = "LGPL-2.0+";
    fullName = "GNU Library General Public License v2 or later";
  };

  lgpl21 = spdx {
    spdxId = "LGPL-2.1";
    fullName = "GNU Library General Public License v2.1 only";
  };

  lgpl21Plus = spdx {
    spdxId = "LGPL-2.1+";
    fullName = "GNU Library General Public License v2.1 or later";
  };

  lgpl3 = spdx {
    spdxId = "LGPL-3.0";
    fullName = "GNU Lesser General Public License v3.0 only";
  };

  lgpl3Plus = spdx {
    spdxId = "LGPL-3.0+";
    fullName = "GNU Lesser General Public License v3.0 or later";
  };

  libpng = spdx {
    spdxId = "Libpng";
    fullName = "libpng License";
  };

  libtiff = spdx {
    spdxId = "libtiff";
    fullName = "libtiff License";
  };

  llgpl21 = {
    fullName = "Lisp LGPL; GNU Lesser General Public License version 2.1 with Franz Inc. preamble for clarification of LGPL terms in context of Lisp";
    url = http://opensource.franz.com/preamble.html;
  };

  lppl12 = spdx {
    spdxId = "LPPL-1.2";
    fullName = "LaTeX Project Public License v1.2";
  };

  lpl-102 = spdx {
    spdxId = "LPL-1.02";
    fullName = "Lucent Public License v1.02";
  };

  # spdx.org does not (yet) differentiate between the X11 and Expat versions
  # for details see http://en.wikipedia.org/wiki/MIT_License#Various_versions
  mit = spdx {
    spdxId = "MIT";
    fullName = "MIT License";
  };

  mpl11 = spdx {
    spdxId = "MPL-1.1";
    fullName = "Mozilla Public License 1.1";
  };

  mpl20 = spdx {
    spdxId = "MPL-2.0";
    fullName = "Mozilla Public License 2.0";
  };

  msrla = {
    fullName  = "Microsoft Research License Agreement";
    url       = "http://research.microsoft.com/en-us/projects/pex/msr-la.txt";
  };

  ncsa = spdx {
    spdxId = "NCSA";
    fullName  = "University of Illinois/NCSA Open Source License";
  };

  ofl = spdx {
    spdxId = "OFL-1.1";
    fullName = "SIL Open Font License 1.1";
  };

  openssl = spdx {
    spdxId = "OpenSSL";
    fullName = "OpenSSL License";
  };

  php301 = spdx {
    spdxId = "PHP-3.01";
    fullName = "PHP License v3.01";
  };

  postgresql = spdx {
    spdxId = "PostgreSQL";
    fullName = "PostgreSQL License";
  };

  psfl = spdx {
    spdxId = "Python-2.0";
    fullName = "Python Software Foundation License version 2";
    #url = http://docs.python.org/license.html;
  };

  publicDomain = {
    fullName = "Public Domain";
  };

  qpl = spdx {
    spdxId = "QPL-1.0";
    fullName = "Q Public License 1.0";
  };

  qwt = {
    fullName = "Qwt License, Version 1.0";
    url = http://qwt.sourceforge.net/qwtlicense.html;
  };

  ruby = spdx {
    spdxId = "Ruby";
    fullName = "Ruby License";
  };

  sgi-b-20 = spdx {
    spdxId = "SGI-B-2.0";
    fullName = "SGI Free Software License B v2.0";
  };

  sleepycat = spdx {
    spdxId = "Sleepycat";
    fullName = "Sleepycat License";
  };

  tcltk = spdx {
    spdxId = "TCL";
    fullName = "TCL/TK License";
  };

  unfree = {
    fullName = "Unfree";
    free = false;
  };

  unfreeRedistributable = {
    fullName = "Unfree redistributable";
    free = false;
  };

  unfreeRedistributableFirmware = {
    fullName = "Unfree redistributable firmware";
    # Note: we currently consider these "free" for inclusion in the
    # channel and NixOS images.
  };

  unlicense = spdx {
    spdxId = "Unlicense";
    fullName = "The Unlicense";
  };

  vsl10 = spdx {
    spdxId = "VSL-1.0";
    fullName = "Vovida Software License v1.0";
  };

  w3c = spdx {
    spdxId = "W3C";
    fullName = "W3C Software Notice and License";
  };

  wadalab = {
    fullName = "Wadalab Font License";
    url = https://fedoraproject.org/wiki/Licensing:Wadalab?rd=Licensing/Wadalab;
  };

  wtfpl = spdx {
    spdxId = "WTFPL";
    fullName = "Do What The F*ck You Want To Public License";
  };

  zlib = spdx {
    spdxId = "Zlib";
    fullName = "zlib License";
  };

  zpt20 = spdx { # FIXME: why zpt* instead of zpl*
    spdxId = "ZPL-2.0";
    fullName = "Zope Public License 2.0";
  };

  zpt21 = spdx {
    spdxId = "ZPL-2.1";
    fullName = "Zope Public License 2.1";
  };

}
