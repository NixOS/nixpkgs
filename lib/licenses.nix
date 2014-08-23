let
  spdx = lic: lic // {
      url = "http://spdx.org/licenses/${lic.shortName}";
    };
in

rec {
  /* License identifiers from spdx.org where possible.
   * If you cannot find your license here, then look for a similar license or
   * add it to this list. The URL mentioned above is a good source for inspiration.
   */

  agpl3 = spdx {
    shortName = "AGPL-3.0";
    fullName = "GNU Affero General Public License v3.0";
  };

  agpl3Plus = {
    shortName = "AGPL-3.0+";
    fullName = "GNU Affero General Public License v3.0 or later";
    inherit (agpl3) url;
  };

  amd = {
    shortName = "amd";
    fullName = "AMD License Agreement";
    url = http://developer.amd.com/amd-license-agreement/;
  };#

  apsl20 = spdx {
    shortName = "APSL-2.0";
    fullName = "Apple Public Source License 2.0";
  };

  artistic2 = spdx {
    shortName = "Artistic-2.0";
    fullName = "Artistic License 2.0";
  };

  asl20 = spdx {
    shortName = "Apache-2.0";
    fullName = "Apache License 2.0";
  };

  boost = spdx {
    shortName = "BSL-1.0";
    fullName = "Boost Software License 1.0";
  };

  bsd2 = spdx {
    shortName = "BSD-2-Clause";
    fullName = ''BSD 2-clause "Simplified" License'';
  };

  bsd3 = spdx {
    shortName = "BSD-3-Clause";
    fullName = ''BSD 3-clause "New" or "Revised" License'';
  };

  bsdOriginal = spdx {
    shortName = "BSD-4-Clause";
    fullName = ''BSD 4-clause "Original" or "Old" License'';
  };

  cc-by-30 = spdx {
    shortName = "CC-BY-3.0";
    fullName = "Creative Commons Attribution 3.0";
  };

  cddl = spdx {
    shortName = "CDDL-1.0";
    fullName = "Common Development and Distribution License 1.0";
  };

  cecill-c = spdx {
    shortName = "CECILL-C";
    fullName  = "CeCILL-C Free Software License Agreement";
  };

  cpl10 = spdx {
    shortName = "CPL-1.0";
    fullName = "Common Public License 1.0";
  };

  epl10 = spdx {
    shortName = "EPL-1.0";
    fullName = "Eclipse Public License 1.0";
  };

  free = "free";

  gpl2 = spdx {
    shortName = "GPL-2.0";
    fullName = "GNU General Public License v2.0 only";
  };

  gpl2Oss = {
    shortName = "GPL-2.0-with-OSS";
    fullName = "GNU General Public License version 2 only (with OSI approved licenses linking exception)";
    url = http://www.mysql.com/about/legal/licensing/foss-exception;
  };

  gpl2Plus = spdx {
    shortName = "GPL-2.0+";
    fullName = "GNU General Public License v2.0 or later";
  };

  gpl3 = spdx {
    shortName = "GPL-3.0";
    fullName = "GNU General Public License v3.0 only";
  };

  gpl3Plus = spdx {
    shortName = "GPL-3.0+";
    fullName = "GNU General Public License v3.0 or later";
  };

  gpl3ClasspathPlus = {
    shortName = "GPL-3.0+-with-classpath-exception";
    fullName = "GNU General Public License v3.0 or later (with Classpath exception)";
    url = https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception;
  };

  inria = {
    shortName = "INRIA-NCLA";
    fullName  = "INRIA Non-Commercial License Agreement";
    url       = "http://compcert.inria.fr/doc/LICENSE";
  };

  ipa = spdx {
    shortName = "IPA";
    fullName = "IPA Font License";
  };

  ipl10 = spdx {
    shortName = "IPL-1.0";
    fullName = "IBM Public License v1.0";
  };

  isc = spdx {
    shortName = "ISC";
    fullName = "ISC License";
  };

  lgpl2 = spdx {
    shortName = "LGPL-2.0";
    fullName = "GNU Library General Public License v2 only";
  };

  lgpl2Plus = spdx {
    shortName = "LGPL-2.0+";
    fullName = "GNU Library General Public License v2 or later";
  };

  lgpl21 = spdx {
    shortName = "LGPL-2.1";
    fullName = "GNU Library General Public License v2.1 only";
  };

  lgpl21Plus = spdx {
    shortName = "LGPL-2.1+";
    fullName = "GNU Library General Public License v2.1 or later";
  };

  lgpl3 = spdx {
    shortName = "LGPL-3.0";
    fullName = "GNU Lesser General Public License v3.0 only";
  };

  lgpl3Plus = spdx {
    shortName = "LGPL-3.0+";
    fullName = "GNU Lesser General Public License v3.0 or later";
  };

  libtiff = {
    shortName = "libtiff";
    fullName = "libtiff license";
    url = https://fedoraproject.org/wiki/Licensing/libtiff;
  };

  llgpl21 = {
    shortName = "LLGPL-2.1";
    fullName = "Lisp LGPL; GNU Lesser General Public License version 2.1 with Franz Inc. preamble for clarification of LGPL terms in context of Lisp";
    url = http://opensource.franz.com/preamble.html;
  };

  lpl-102 = spdx {
    shortName = "LPL-1.02";
    fullName = "Lucent Public License v1.02";
  };

  mit = spdx {
    shortName = "MIT";
    fullName = "MIT License";
  };

  mpl11 = spdx {
    shortName = "MPL-1.1";
    fullName = "Mozilla Public License 1.1";
  };

  mpl20 = spdx {
    shortName = "MPL-2.0";
    fullName = "Mozilla Public License 2.0";
  };

  msrla = {
    shortName = "MSR-LA";
    fullName  = "Microsoft Research License Agreement";
    url       = "http://research.microsoft.com/en-us/projects/pex/msr-la.txt";
  };

  ofl = spdx {
    shortName = "OFL-1.1";
    fullName = "SIL Open Font License 1.1";
  };

  openssl = spdx {
    shortName = "OpenSSL";
    fullName = "OpenSSL License";
  };

  psfl = spdx {
    shortName = "Python-2.0";
    fullName = "Python Software Foundation License version 2";
    #url = http://docs.python.org/license.html;
  };

  publicDomain = {
    shortName = "Public Domain";
    fullname = "Public Domain";
  };

  sleepycat = spdx {
    shortName = "Sleepycat";
    fullName  = "Sleepycat License";
  };

  tcltk = {
    shortName = "Tcl/Tk";
    fullName = "Tcl/Tk license";
    url = http://www.tcl.tk/software/tcltk/license.html;
  };

  unfree = "unfree";

  unfreeRedistributable = "unfree-redistributable";

  unfreeRedistributableFirmware = "unfree-redistributable-firmware";

  wadalab = {
    shortName = "wadalab";
    fullName = "Wadalab Font License";
    url = https://fedoraproject.org/wiki/Licensing:Wadalab?rd=Licensing/Wadalab;
  };

  zlib = spdx {
    shortName = "Zlib";
    fullName = "zlib License";
  };

  zpt20 = spdx { # FIXME: why zpt* instead of zpl*
    shortName = "ZPL-2.0";
    fullName = "Zope Public License 2.0";
  };

  zpt21 = spdx {
    shortName = "ZPL-2.1";
    fullName = "Zope Public License 2.1";
  };

}

