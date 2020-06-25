{ lib }:
let

  spdx = lic: lic // {
    url = "https://spdx.org/licenses/${lic.spdxId}.html";
  };

in

lib.mapAttrs (n: v: v // { shortName = n; }) {
  /* License identifiers from spdx.org where possible.
   * If you cannot find your license here, then look for a similar license or
   * add it to this list. The URL mentioned above is a good source for inspiration.
   */

  abstyles = spdx {
    spdxId = "Abstyles";
    fullName = "Abstyles License";
  };

  afl21 = spdx {
    spdxId = "AFL-2.1";
    fullName = "Academic Free License v2.1";
  };

  afl3 = spdx {
    spdxId = "AFL-3.0";
    fullName = "Academic Free License v3.0";
  };

  agpl3 = spdx {
    spdxId = "AGPL-3.0-only";
    fullName = "GNU Affero General Public License v3.0 only";
  };

  agpl3Plus = spdx {
    spdxId = "AGPL-3.0-or-later";
    fullName = "GNU Affero General Public License v3.0 or later";
  };

  amazonsl = {
    fullName = "Amazon Software License";
    url = "https://aws.amazon.com/asl/";
    free = false;
  };

  amd = {
    fullName = "AMD License Agreement";
    url = "https://developer.amd.com/amd-license-agreement/";
    free = false;
  };

  apsl20 = spdx {
    spdxId = "APSL-2.0";
    fullName = "Apple Public Source License 2.0";
  };

  arphicpl = {
    fullName = "Arphic Public License";
    url = "https://www.freedesktop.org/wiki/Arphic_Public_License/";
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

  beerware = spdx {
    spdxId = "Beerware";
    fullName = ''Beerware License'';
  };

  bsd0 = spdx {
    spdxId = "0BSD";
    fullName = "BSD Zero Clause License";
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

  bsl11 = {
    fullName = "Business Source License 1.1";
    url = "https://mariadb.com/bsl11";
    free = false;
  };

  clArtistic = spdx {
    spdxId = "ClArtistic";
    fullName = "Clarified Artistic License";
  };

  cc0 = spdx {
    spdxId = "CC0-1.0";
    fullName = "Creative Commons Zero v1.0 Universal";
  };

  cc-by-nc-sa-20 = spdx {
    spdxId = "CC-BY-NC-SA-2.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 2.0";
    free = false;
  };

  cc-by-nc-sa-25 = spdx {
    spdxId = "CC-BY-NC-SA-2.5";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 2.5";
    free = false;
  };

  cc-by-nc-sa-30 = spdx {
    spdxId = "CC-BY-NC-SA-3.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 3.0";
    free = false;
  };

  cc-by-nc-sa-40 = spdx {
    spdxId = "CC-BY-NC-SA-4.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 4.0";
    free = false;
  };

  cc-by-nc-30 = spdx {
    spdxId = "CC-BY-NC-3.0";
    fullName = "Creative Commons Attribution Non Commercial 3.0 Unported";
    free = false;
  };

  cc-by-nc-40 = spdx {
    spdxId = "CC-BY-NC-4.0";
    fullName = "Creative Commons Attribution Non Commercial 4.0 International";
    free = false;
  };

  cc-by-nd-30 = spdx {
    spdxId = "CC-BY-ND-3.0";
    fullName = "Creative Commons Attribution-No Derivative Works v3.00";
    free = false;
  };

  cc-by-sa-25 = spdx {
    spdxId = "CC-BY-SA-2.5";
    fullName = "Creative Commons Attribution Share Alike 2.5";
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

  cc-by-sa-40 = spdx {
    spdxId = "CC-BY-SA-4.0";
    fullName = "Creative Commons Attribution Share Alike 4.0";
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

  cpal10 = spdx {
    spdxId = "CPAL-1.0";
    fullName = "Common Public Attribution License 1.0";
  };

  cpl10 = spdx {
    spdxId = "CPL-1.0";
    fullName = "Common Public License 1.0";
  };

  curl = spdx {
    spdxId = "curl";
    fullName = "curl License";
  };

  doc = spdx {
    spdxId = "DOC";
    fullName = "DOC License";
  };

  eapl = {
    fullName = "EPSON AVASYS PUBLIC LICENSE";
    url = "https://avasys.jp/hp/menu000000700/hpg000000603.htm";
    free = false;
  };

  efl10 = spdx {
    spdxId = "EFL-1.0";
    fullName = "Eiffel Forum License v1.0";
  };

  efl20 = spdx {
    spdxId = "EFL-2.0";
    fullName = "Eiffel Forum License v2.0";
  };

  elastic = {
    fullName = "ELASTIC LICENSE";
    url = "https://github.com/elastic/elasticsearch/blob/master/licenses/ELASTIC-LICENSE.txt";
    free = false;
  };

  epl10 = spdx {
    spdxId = "EPL-1.0";
    fullName = "Eclipse Public License 1.0";
  };

  epl20 = spdx {
    spdxId = "EPL-2.0";
    fullName = "Eclipse Public License 2.0";
  };

  epson = {
    fullName = "Seiko Epson Corporation Software License Agreement for Linux";
    url = "https://download.ebz.epson.net/dsc/du/02/eula/global/LINUX_EN.html";
    free = false;
  };

  eupl11 = spdx {
    spdxId = "EUPL-1.1";
    fullName = "European Union Public License 1.1";
  };

  eupl12 = spdx {
    spdxId = "EUPL-1.2";
    fullName = "European Union Public License 1.2";
  };

  fdl11 = spdx {
    spdxId = "GFDL-1.1-only";
    fullName = "GNU Free Documentation License v1.1 only";
  };

  fdl12 = spdx {
    spdxId = "GFDL-1.2-only";
    fullName = "GNU Free Documentation License v1.2 only";
  };

  fdl12Plus = spdx {
    spdxId = "GFDL-1.2-or-later";
    fullName = "GNU Free Documentation License v1.2 or later";
  };

  fdl13 = spdx {
    spdxId = "GFDL-1.3-only";
    fullName = "GNU Free Documentation License v1.3 only";
  };

  fdl13Plus = spdx {
    spdxId = "GFDL-1.3-or-later";
    fullName = "GNU Free Documentation License v1.3 or later";
  };

  ffsl = {
    fullName = "Floodgap Free Software License";
    url = "https://www.floodgap.com/software/ffsl/license.html";
    free = false;
  };

  free = {
    fullName = "Unspecified free software license";
  };

  g4sl = {
    fullName = "Geant4 Software License";
    url = "https://geant4.web.cern.ch/geant4/license/LICENSE.html";
  };

  geogebra = {
    fullName = "GeoGebra Non-Commercial License Agreement";
    url = "https://www.geogebra.org/license";
    free = false;
  };

  gpl1 = spdx {
    spdxId = "GPL-1.0-only";
    fullName = "GNU General Public License v1.0 only";
  };

  gpl1Plus = spdx {
    spdxId = "GPL-1.0-or-later";
    fullName = "GNU General Public License v1.0 or later";
  };

  gpl2 = spdx {
    spdxId = "GPL-2.0-only";
    fullName = "GNU General Public License v2.0 only";
  };

  gpl2Classpath = spdx {
    spdxId = "GPL-2.0-with-classpath-exception";
    fullName = "GNU General Public License v2.0 only (with Classpath exception)";
  };

  gpl2ClasspathPlus = {
    fullName = "GNU General Public License v2.0 or later (with Classpath exception)";
    url = "https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception";
  };

  gpl2Oss = {
    fullName = "GNU General Public License version 2 only (with OSI approved licenses linking exception)";
    url = "https://www.mysql.com/about/legal/licensing/foss-exception";
  };

  gpl2Plus = spdx {
    spdxId = "GPL-2.0-or-later";
    fullName = "GNU General Public License v2.0 or later";
  };

  gpl3 = spdx {
    spdxId = "GPL-3.0-only";
    fullName = "GNU General Public License v3.0 only";
  };

  gpl3Plus = spdx {
    spdxId = "GPL-3.0-or-later";
    fullName = "GNU General Public License v3.0 or later";
  };

  gpl3ClasspathPlus = {
    fullName = "GNU General Public License v3.0 or later (with Classpath exception)";
    url = "https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception";
  };

  hpnd = spdx {
    spdxId = "HPND";
    fullName = "Historic Permission Notice and Disclaimer";
  };

  # Intel's license, seems free
  iasl = {
    fullName = "iASL";
    url = "https://old.calculate-linux.org/packages/licenses/iASL";
  };

  ijg = spdx {
    spdxId = "IJG";
    fullName = "Independent JPEG Group License";
  };

  imagemagick = spdx {
    fullName = "ImageMagick License";
    spdxId = "imagemagick";
  };

  inria-compcert = {
    fullName  = "INRIA Non-Commercial License Agreement for the CompCert verified compiler";
    url       = "http://compcert.inria.fr/doc/LICENSE"; # https is broken
    free      = false;
  };

  inria-icesl = {
    fullName = "INRIA Non-Commercial License Agreement for IceSL";
    url      = "http://shapeforge.loria.fr/icesl/EULA_IceSL_binary.pdf"; # https is broken
    free     = false;
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

  # Proprietary binaries; free to redistribute without modification.
  issl = {
    fullName = "Intel Simplified Software License";
    url = "https://software.intel.com/en-us/license/intel-simplified-software-license";
    free = false;
  };

  jasper = spdx {
    spdxId = "JasPer-2.0";
    fullName = "JasPer License";
  };

  lgpl2 = spdx {
    spdxId = "LGPL-2.0-only";
    fullName = "GNU Library General Public License v2 only";
  };

  lgpl2Plus = spdx {
    spdxId = "LGPL-2.0-or-later";
    fullName = "GNU Library General Public License v2 or later";
  };

  lgpl21 = spdx {
    spdxId = "LGPL-2.1-only";
    fullName = "GNU Lesser General Public License v2.1 only";
  };

  lgpl21Plus = spdx {
    spdxId = "LGPL-2.1-or-later";
    fullName = "GNU Lesser General Public License v2.1 or later";
  };

  lgpl3 = spdx {
    spdxId = "LGPL-3.0-only";
    fullName = "GNU Lesser General Public License v3.0 only";
  };

  lgpl3Plus = spdx {
    spdxId = "LGPL-3.0-or-later";
    fullName = "GNU Lesser General Public License v3.0 or later";
  };

  libpng = spdx {
    spdxId = "Libpng";
    fullName = "libpng License";
  };

  libpng2 = spdx {
    spdxId = "libpng-2.0"; # Used since libpng 1.6.36.
    fullName = "PNG Reference Library version 2";
  };

  libtiff = spdx {
    spdxId = "libtiff";
    fullName = "libtiff License";
  };

  llgpl21 = {
    fullName = "Lisp LGPL; GNU Lesser General Public License version 2.1 with Franz Inc. preamble for clarification of LGPL terms in context of Lisp";
    url = "https://opensource.franz.com/preamble.html";
  };

  lppl12 = spdx {
    spdxId = "LPPL-1.2";
    fullName = "LaTeX Project Public License v1.2";
  };

  lppl13c = spdx {
    spdxId = "LPPL-1.3c";
    fullName = "LaTeX Project Public License v1.3c";
  };

  lpl-102 = spdx {
    spdxId = "LPL-1.02";
    fullName = "Lucent Public License v1.02";
  };

  miros = {
    fullName = "MirOS License";
    url = "https://opensource.org/licenses/MirOS";
  };

  # spdx.org does not (yet) differentiate between the X11 and Expat versions
  # for details see https://en.wikipedia.org/wiki/MIT_License#Various_versions
  mit = spdx {
    spdxId = "MIT";
    fullName = "MIT License";
  };

  mpl10 = spdx {
    spdxId = "MPL-1.0";
    fullName = "Mozilla Public License 1.0";
  };

  mpl11 = spdx {
    spdxId = "MPL-1.1";
    fullName = "Mozilla Public License 1.1";
  };

  mpl20 = spdx {
    spdxId = "MPL-2.0";
    fullName = "Mozilla Public License 2.0";
  };

  mspl = spdx {
    spdxId = "MS-PL";
    fullName = "Microsoft Public License";
  };

  nasa13 = spdx {
    spdxId = "NASA-1.3";
    fullName = "NASA Open Source Agreement 1.3";
    free = false;
  };

  ncsa = spdx {
    spdxId = "NCSA";
    fullName  = "University of Illinois/NCSA Open Source License";
  };

  nposl3 = spdx {
    spdxId = "NPOSL-3.0";
    fullName = "Non-Profit Open Software License 3.0";
  };

  obsidian = {
    fullName = "Obsidian End User Agreement";
    url = "https://obsidian.md/eula";
    free = false;
  };

  ocamlpro_nc = {
    fullName = "OCamlPro Non Commercial license version 1";
    url = "https://alt-ergo.ocamlpro.com/http/alt-ergo-2.2.0/OCamlPro-Non-Commercial-License.pdf";
    free = false;
  };

  ofl = spdx {
    spdxId = "OFL-1.1";
    fullName = "SIL Open Font License 1.1";
  };

  openldap = spdx {
    spdxId = "OLDAP-2.8";
    fullName = "Open LDAP Public License v2.8";
  };

  openssl = spdx {
    spdxId = "OpenSSL";
    fullName = "OpenSSL License";
  };

  osl2 = spdx {
    spdxId = "OSL-2.0";
    fullName = "Open Software License 2.0";
  };

  osl21 = spdx {
    spdxId = "OSL-2.1";
    fullName = "Open Software License 2.1";
  };

  osl3 = spdx {
    spdxId = "OSL-3.0";
    fullName = "Open Software License 3.0";
  };

  php301 = spdx {
    spdxId = "PHP-3.01";
    fullName = "PHP License v3.01";
  };

  postgresql = spdx {
    spdxId = "PostgreSQL";
    fullName = "PostgreSQL License";
  };

  postman = {
    fullName = "Postman EULA";
    url = "https://www.getpostman.com/licenses/postman_base_app";
    free = false;
  };

  psfl = spdx {
    spdxId = "Python-2.0";
    fullName = "Python Software Foundation License version 2";
    url = "https://docs.python.org/license.html";
  };

  publicDomain = {
    fullName = "Public Domain";
  };

  purdueBsd = {
    fullName = " Purdue BSD-Style License"; # also know as lsof license
    url = "https://enterprise.dejacode.com/licenses/public/purdue-bsd";
  };

  qhull = spdx {
    spdxId = "Qhull";
    fullName = "Qhull License";
  };

  qpl = spdx {
    spdxId = "QPL-1.0";
    fullName = "Q Public License 1.0";
  };

  qwt = {
    fullName = "Qwt License, Version 1.0";
    url = "https://qwt.sourceforge.io/qwtlicense.html";
  };

  ruby = spdx {
    spdxId = "Ruby";
    fullName = "Ruby License";
  };

  sendmail = spdx {
    spdxId = "Sendmail";
    fullName = "Sendmail License";
  };

  sgi-b-20 = spdx {
    spdxId = "SGI-B-2.0";
    fullName = "SGI Free Software License B v2.0";
  };

  sleepycat = spdx {
    spdxId = "Sleepycat";
    fullName = "Sleepycat License";
  };

  smail = {
    shortName = "smail";
    fullName = "SMAIL General Public License";
    url = "https://sources.debian.org/copyright/license/debianutils/4.9.1/";
  };

  sspl = {
    shortName = "SSPL";
    fullName = "Server Side Public License";
    url = "https://www.mongodb.com/licensing/server-side-public-license";
    free = false;
  };

  tcltk = spdx {
    spdxId = "TCL";
    fullName = "TCL/TK License";
  };

  ufl = {
    fullName = "Ubuntu Font License 1.0";
    url = "https://ubuntu.com/legal/font-licence";
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

  unicode-dfs-2016 = spdx {
    spdxId = "Unicode-DFS-2016";
    fullName = "Unicode License Agreement - Data Files and Software (2016)";
  };

  unlicense = spdx {
    spdxId = "Unlicense";
    fullName = "The Unlicense";
  };

  upl = {
    fullName = "Universal Permissive License";
    url = "https://oss.oracle.com/licenses/upl/";
  };

  vim = spdx {
    spdxId = "Vim";
    fullName = "Vim License";
  };

  virtualbox-puel = {
    fullName = "Oracle VM VirtualBox Extension Pack Personal Use and Evaluation License (PUEL)";
    url = "https://www.virtualbox.org/wiki/VirtualBox_PUEL";
    free = false;
  };

  vsl10 = spdx {
    spdxId = "VSL-1.0";
    fullName = "Vovida Software License v1.0";
  };

  watcom = spdx {
    spdxId = "Watcom-1.0";
    fullName = "Sybase Open Watcom Public License 1.0";
  };

  w3c = spdx {
    spdxId = "W3C";
    fullName = "W3C Software Notice and License";
  };

  wadalab = {
    fullName = "Wadalab Font License";
    url = "https://fedoraproject.org/wiki/Licensing:Wadalab?rd=Licensing/Wadalab";
  };

  wtfpl = spdx {
    spdxId = "WTFPL";
    fullName = "Do What The F*ck You Want To Public License";
  };

  wxWindows = spdx {
    spdxId = "wxWindows";
    fullName = "wxWindows Library Licence, Version 3.1";
  };

  xfig = {
    fullName = "xfig";
    url = "http://mcj.sourceforge.net/authors.html#xfig"; # https is broken
  };

  zlib = spdx {
    spdxId = "Zlib";
    fullName = "zlib License";
  };

  zpl20 = spdx {
    spdxId = "ZPL-2.0";
    fullName = "Zope Public License 2.0";
  };

  zpl21 = spdx {
    spdxId = "ZPL-2.1";
    fullName = "Zope Public License 2.1";
  };
}
