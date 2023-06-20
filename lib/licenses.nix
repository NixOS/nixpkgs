{ lib }:

lib.mapAttrs (lname: lset: let
  defaultLicense = rec {
    shortName = lname;
    free = true; # Most of our licenses are Free, explicitly declare unfree additions as such!
    deprecated = false;
  };

  mkLicense = licenseDeclaration: let
    applyDefaults = license: defaultLicense // license;
    applySpdx = license:
      if license ? spdxId
      then license // { url = "https://spdx.org/licenses/${license.spdxId}.html"; }
      else license;
    applyRedistributable = license: { redistributable = license.free; } // license;
  in lib.pipe licenseDeclaration [
    applyDefaults
    applySpdx
    applyRedistributable
  ];
in mkLicense lset) ({
  /* License identifiers from spdx.org where possible.
   * If you cannot find your license here, then look for a similar license or
   * add it to this list. The URL mentioned above is a good source for inspiration.
   */

  abstyles = {
    spdxId = "Abstyles";
    fullName = "Abstyles License";
  };

  afl20 = {
    spdxId = "AFL-2.0";
    fullName = "Academic Free License v2.0";
  };

  afl21 = {
    spdxId = "AFL-2.1";
    fullName = "Academic Free License v2.1";
  };

  afl3 = {
    spdxId = "AFL-3.0";
    fullName = "Academic Free License v3.0";
  };

  agpl3Only = {
    spdxId = "AGPL-3.0-only";
    fullName = "GNU Affero General Public License v3.0 only";
  };

  agpl3Plus = {
    spdxId = "AGPL-3.0-or-later";
    fullName = "GNU Affero General Public License v3.0 or later";
  };

  aladdin = {
    spdxId = "Aladdin";
    fullName = "Aladdin Free Public License";
    free = false;
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

  aom = {
    fullName = "Alliance for Open Media Patent License 1.0";
    url = "https://aomedia.org/license/patent-license/";
  };

  apsl10 = {
    spdxId = "APSL-1.0";
    fullName = "Apple Public Source License 1.0";
  };

  apsl20 = {
    spdxId = "APSL-2.0";
    fullName = "Apple Public Source License 2.0";
  };

  arphicpl = {
    fullName = "Arphic Public License";
    url = "https://www.freedesktop.org/wiki/Arphic_Public_License/";
  };

  artistic1 = {
    spdxId = "Artistic-1.0";
    fullName = "Artistic License 1.0";
  };

  artistic1-cl8 = {
    spdxId = "Artistic-1.0-cl8";
    fullName = "Artistic License 1.0 w/clause 8";
  };

  artistic2 = {
    spdxId = "Artistic-2.0";
    fullName = "Artistic License 2.0";
  };

  asl20 = {
    spdxId = "Apache-2.0";
    fullName = "Apache License 2.0";
  };

  asl20-llvm = {
    spdxId = "Apache-2.0 WITH LLVM-exception";
    fullName = "Apache License 2.0 with LLVM Exceptions";
  };

  bitstreamVera = {
    spdxId = "Bitstream-Vera";
    fullName = "Bitstream Vera Font License";
  };

  bitTorrent10 = {
     spdxId = "BitTorrent-1.0";
     fullName = " BitTorrent Open Source License v1.0";
  };

  bitTorrent11 = {
    spdxId = "BitTorrent-1.1";
    fullName = " BitTorrent Open Source License v1.1";
  };

  bola11 = {
    url = "https://blitiri.com.ar/p/bola/";
    fullName = "Buena Onda License Agreement 1.1";
  };

  boost = {
    spdxId = "BSL-1.0";
    fullName = "Boost Software License 1.0";
  };

  beerware = {
    spdxId = "Beerware";
    fullName = "Beerware License";
  };

  blueOak100 = {
    spdxId = "BlueOak-1.0.0";
    fullName = "Blue Oak Model License 1.0.0";
  };

  bsd0 = {
    spdxId = "0BSD";
    fullName = "BSD Zero Clause License";
  };

  bsd1 = {
    spdxId = "BSD-1-Clause";
    fullName = "BSD 1-Clause License";
  };

  bsd2 = {
    spdxId = "BSD-2-Clause";
    fullName = ''BSD 2-clause "Simplified" License'';
  };

  bsd2Patent = {
    spdxId = "BSD-2-Clause-Patent";
    fullName = "BSD-2-Clause Plus Patent License";
  };

  bsd2WithViews = {
    spdxId = "BSD-2-Clause-Views";
    fullName = "BSD 2-Clause with views sentence";
  };

  bsd3 = {
    spdxId = "BSD-3-Clause";
    fullName = ''BSD 3-clause "New" or "Revised" License'';
  };

  bsd3Clear = {
    spdxId = "BSD-3-Clause-Clear";
    fullName = "BSD 3-Clause Clear License";
  };

  bsdOriginal = {
    spdxId = "BSD-4-Clause";
    fullName = ''BSD 4-clause "Original" or "Old" License'';
  };

  bsdOriginalShortened = {
    spdxId = "BSD-4-Clause-Shortened";
    fullName = "BSD 4 Clause Shortened";
  };

  bsdOriginalUC = {
    spdxId = "BSD-4-Clause-UC";
    fullName = "BSD 4-Clause University of California-Specific";
  };

  bsdProtection = {
    spdxId = "BSD-Protection";
    fullName = "BSD Protection License";
  };

  bsl11 = {
    fullName = "Business Source License 1.1";
    url = "https://mariadb.com/bsl11";
    free = false;
    redistributable = true;
  };

  caossl = {
    fullName = "Computer Associates Open Source Licence Version 1.0";
    url = "http://jxplorer.org/licence.html";
  };

  cal10 = {
    fullName = "Cryptographic Autonomy License version 1.0 (CAL-1.0)";
    url = "https://opensource.org/licenses/CAL-1.0";
  };

  caldera = {
    spdxId = "Caldera";
    fullName = "Caldera License";
    url = "http://www.lemis.com/grog/UNIX/ancient-source-all.pdf";
  };

  capec = {
    fullName = "Common Attack Pattern Enumeration and Classification";
    url = "https://capec.mitre.org/about/termsofuse.html";
  };

  clArtistic = {
    spdxId = "ClArtistic";
    fullName = "Clarified Artistic License";
  };

  cc0 = {
    spdxId = "CC0-1.0";
    fullName = "Creative Commons Zero v1.0 Universal";
  };

  cc-by-nc-nd-30 = {
    spdxId = "CC-BY-NC-ND-3.0";
    fullName = "Creative Commons Attribution Non Commercial No Derivative Works 3.0 Unported";
    free = false;
  };

  cc-by-nc-nd-40 = {
    spdxId = "CC-BY-NC-ND-4.0";
    fullName = "Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International";
    free = false;
  };

  cc-by-nc-sa-20 = {
    spdxId = "CC-BY-NC-SA-2.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 2.0";
    free = false;
  };

  cc-by-nc-sa-25 = {
    spdxId = "CC-BY-NC-SA-2.5";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 2.5";
    free = false;
  };

  cc-by-nc-sa-30 = {
    spdxId = "CC-BY-NC-SA-3.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 3.0";
    free = false;
  };

  cc-by-nc-sa-40 = {
    spdxId = "CC-BY-NC-SA-4.0";
    fullName = "Creative Commons Attribution Non Commercial Share Alike 4.0";
    free = false;
  };

  cc-by-nc-30 = {
    spdxId = "CC-BY-NC-3.0";
    fullName = "Creative Commons Attribution Non Commercial 3.0 Unported";
    free = false;
  };

  cc-by-nc-40 = {
    spdxId = "CC-BY-NC-4.0";
    fullName = "Creative Commons Attribution Non Commercial 4.0 International";
    free = false;
  };

  cc-by-nd-30 = {
    spdxId = "CC-BY-ND-3.0";
    fullName = "Creative Commons Attribution-No Derivative Works v3.00";
    free = false;
  };

  cc-by-sa-10 = {
    spdxId = "CC-BY-SA-1.0";
    fullName = "Creative Commons Attribution Share Alike 1.0";
  };

  cc-by-sa-20 = {
    spdxId = "CC-BY-SA-2.0";
    fullName = "Creative Commons Attribution Share Alike 2.0";
  };

  cc-by-sa-25 = {
    spdxId = "CC-BY-SA-2.5";
    fullName = "Creative Commons Attribution Share Alike 2.5";
  };

  cc-by-10 = {
    spdxId = "CC-BY-1.0";
    fullName = "Creative Commons Attribution 1.0";
  };

  cc-by-30 = {
    spdxId = "CC-BY-3.0";
    fullName = "Creative Commons Attribution 3.0";
  };

  cc-by-sa-30 = {
    spdxId = "CC-BY-SA-3.0";
    fullName = "Creative Commons Attribution Share Alike 3.0";
  };

  cc-by-40 = {
    spdxId = "CC-BY-4.0";
    fullName = "Creative Commons Attribution 4.0";
  };

  cc-by-sa-40 = {
    spdxId = "CC-BY-SA-4.0";
    fullName = "Creative Commons Attribution Share Alike 4.0";
  };

  cddl = {
    spdxId = "CDDL-1.0";
    fullName = "Common Development and Distribution License 1.0";
  };

  cecill20 = {
    spdxId = "CECILL-2.0";
    fullName = "CeCILL Free Software License Agreement v2.0";
  };

  cecill21 = {
    spdxId = "CECILL-2.1";
    fullName = "CeCILL Free Software License Agreement v2.1";
  };

  cecill-b = {
    spdxId = "CECILL-B";
    fullName  = "CeCILL-B Free Software License Agreement";
  };

  cecill-c = {
    spdxId = "CECILL-C";
    fullName  = "CeCILL-C Free Software License Agreement";
  };

  cpal10 = {
    spdxId = "CPAL-1.0";
    fullName = "Common Public Attribution License 1.0";
  };

  cpl10 = {
    spdxId = "CPL-1.0";
    fullName = "Common Public License 1.0";
  };

  curl = {
    spdxId = "curl";
    fullName = "curl License";
  };

  doc = {
    spdxId = "DOC";
    fullName = "DOC License";
  };

  drl10 = {
    spdxId = "DRL-1.0";
    fullName = "Detection Rule License 1.0";
  };

  eapl = {
    fullName = "EPSON AVASYS PUBLIC LICENSE";
    url = "https://avasys.jp/hp/menu000000700/hpg000000603.htm";
    free = false;
  };

  ecl20 = {
    fullName = "Educational Community License, Version 2.0";
    url = "https://opensource.org/licenses/ECL-2.0";
    shortName = "ECL 2.0";
    spdxId = "ECL-2.0";
  };

  efl10 = {
    spdxId = "EFL-1.0";
    fullName = "Eiffel Forum License v1.0";
  };

  efl20 = {
    spdxId = "EFL-2.0";
    fullName = "Eiffel Forum License v2.0";
  };

  elastic = {
    fullName = "ELASTIC LICENSE";
    url = "https://github.com/elastic/elasticsearch/blob/master/licenses/ELASTIC-LICENSE.txt";
    free = false;
  };

  epl10 = {
    spdxId = "EPL-1.0";
    fullName = "Eclipse Public License 1.0";
  };

  epl20 = {
    spdxId = "EPL-2.0";
    fullName = "Eclipse Public License 2.0";
  };

  epson = {
    fullName = "Seiko Epson Corporation Software License Agreement for Linux";
    url = "https://download.ebz.epson.net/dsc/du/02/eula/global/LINUX_EN.html";
    free = false;
  };

  eupl11 = {
    spdxId = "EUPL-1.1";
    fullName = "European Union Public License 1.1";
  };

  eupl12 = {
    spdxId = "EUPL-1.2";
    fullName = "European Union Public License 1.2";
  };

  fdl11Only = {
    spdxId = "GFDL-1.1-only";
    fullName = "GNU Free Documentation License v1.1 only";
  };

  fdl11Plus = {
    spdxId = "GFDL-1.1-or-later";
    fullName = "GNU Free Documentation License v1.1 or later";
  };

  fdl12Only = {
    spdxId = "GFDL-1.2-only";
    fullName = "GNU Free Documentation License v1.2 only";
  };

  fdl12Plus = {
    spdxId = "GFDL-1.2-or-later";
    fullName = "GNU Free Documentation License v1.2 or later";
  };

  fdl13Only = {
    spdxId = "GFDL-1.3-only";
    fullName = "GNU Free Documentation License v1.3 only";
  };

  fdl13Plus = {
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

  ftl = {
    spdxId = "FTL";
    fullName = "Freetype Project License";
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

  generaluser = {
    fullName = "GeneralUser GS License v2.0";
    url = "http://www.schristiancollins.com/generaluser.php"; # license included in sources
  };

  gfl = {
    fullName = "GUST Font License";
    url = "http://www.gust.org.pl/fonts/licenses/GUST-FONT-LICENSE.txt";
  };

  gfsl = {
    fullName = "GUST Font Source License";
    url = "http://www.gust.org.pl/fonts/licenses/GUST-FONT-SOURCE-LICENSE.txt";
  };

  gpl1Only = {
    spdxId = "GPL-1.0-only";
    fullName = "GNU General Public License v1.0 only";
  };

  gpl1Plus = {
    spdxId = "GPL-1.0-or-later";
    fullName = "GNU General Public License v1.0 or later";
  };

  gpl2Only = {
    spdxId = "GPL-2.0-only";
    fullName = "GNU General Public License v2.0 only";
  };

  gpl2Classpath = {
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

  gpl2Plus = {
    spdxId = "GPL-2.0-or-later";
    fullName = "GNU General Public License v2.0 or later";
  };

  gpl3Only = {
    spdxId = "GPL-3.0-only";
    fullName = "GNU General Public License v3.0 only";
  };

  gpl3Plus = {
    spdxId = "GPL-3.0-or-later";
    fullName = "GNU General Public License v3.0 or later";
  };

  gpl3ClasspathPlus = {
    fullName = "GNU General Public License v3.0 or later (with Classpath exception)";
    url = "https://fedoraproject.org/wiki/Licensing/GPL_Classpath_Exception";
  };

  hpnd = {
    spdxId = "HPND";
    fullName = "Historic Permission Notice and Disclaimer";
  };

  hpndSellVariant = {
    fullName = "Historical Permission Notice and Disclaimer - sell variant";
    spdxId = "HPND-sell-variant";
  };

  # Intel's license, seems free
  iasl = {
    fullName = "iASL";
    url = "https://old.calculate-linux.org/packages/licenses/iASL";
  };

  ijg = {
    spdxId = "IJG";
    fullName = "Independent JPEG Group License";
  };

  imagemagick = {
    fullName = "ImageMagick License";
    spdxId = "imagemagick";
  };

  imlib2 = {
    spdxId = "Imlib2";
    fullName = "Imlib2 License";
  };

  info-zip = {
    spdxId = "Info-ZIP";
    fullName = "Info-ZIP License";
    url = "http://www.info-zip.org/pub/infozip/license.html";
  };

  inria-compcert = {
    fullName  = "INRIA Non-Commercial License Agreement for the CompCert verified compiler";
    url       = "https://compcert.org/doc/LICENSE.txt";
    free      = false;
  };

  inria-icesl = {
    fullName = "INRIA Non-Commercial License Agreement for IceSL";
    url      = "https://icesl.loria.fr/assets/pdf/EULA_IceSL_binary.pdf";
    free     = false;
  };

  ipa = {
    spdxId = "IPA";
    fullName = "IPA Font License";
  };

  ipl10 = {
    spdxId = "IPL-1.0";
    fullName = "IBM Public License v1.0";
  };

  isc = {
    spdxId = "ISC";
    fullName = "ISC License";
  };

  # Proprietary binaries; free to redistribute without modification.
  databricks = {
    fullName = "Databricks Proprietary License";
    url = "https://pypi.org/project/databricks-connect";
    free = false;
  };

  databricks-dbx = {
    fullName = "DataBricks eXtensions aka dbx License";
    url = "https://github.com/databrickslabs/dbx/blob/743b579a4ac44531f764c6e522dbe5a81a7dc0e4/LICENSE";
    free = false;
    redistributable = false;
  };

  fair = {
    fullName = "Fair License";
    spdxId = "Fair";
    free = true;
  };

  issl = {
    fullName = "Intel Simplified Software License";
    url = "https://software.intel.com/en-us/license/intel-simplified-software-license";
    free = false;
  };

  knuth = {
    fullName = "Knuth CTAN License";
    spdxId = "Knuth-CTAN";
  };

  lal12 = {
    spdxId = "LAL-1.2";
    fullName = "Licence Art Libre 1.2";
  };

  lal13 = {
    spdxId = "LAL-1.3";
    fullName = "Licence Art Libre 1.3";
  };

  lens = {
    fullName = "Lens Terms of Service Agreement";
    url = "https://k8slens.dev/licenses/tos";
    free = false;
  };

  lgpl2Only = {
    spdxId = "LGPL-2.0-only";
    fullName = "GNU Library General Public License v2 only";
  };

  lgpl2Plus = {
    spdxId = "LGPL-2.0-or-later";
    fullName = "GNU Library General Public License v2 or later";
  };

  lgpl21Only = {
    spdxId = "LGPL-2.1-only";
    fullName = "GNU Lesser General Public License v2.1 only";
  };

  lgpl21Plus = {
    spdxId = "LGPL-2.1-or-later";
    fullName = "GNU Lesser General Public License v2.1 or later";
  };

  lgpl3Only = {
    spdxId = "LGPL-3.0-only";
    fullName = "GNU Lesser General Public License v3.0 only";
  };

  lgpl3Plus = {
    spdxId = "LGPL-3.0-or-later";
    fullName = "GNU Lesser General Public License v3.0 or later";
  };

  lgpllr = {
    spdxId = "LGPLLR";
    fullName = "Lesser General Public License For Linguistic Resources";
  };

  libpng = {
    spdxId = "Libpng";
    fullName = "libpng License";
  };

  libpng2 = {
    spdxId = "libpng-2.0"; # Used since libpng 1.6.36.
    fullName = "PNG Reference Library version 2";
  };

  libssh2 = {
    fullName = "libssh2 License";
    url = "https://www.libssh2.org/license.html";
  };

  libtiff = {
    spdxId = "libtiff";
    fullName = "libtiff License";
  };

  llgpl21 = {
    fullName = "Lisp LGPL; GNU Lesser General Public License version 2.1 with Franz Inc. preamble for clarification of LGPL terms in context of Lisp";
    url = "https://opensource.franz.com/preamble.html";
  };

  lppl1 = {
    spdxId = "LPPL-1.0";
    fullName = "LaTeX Project Public License v1.0";
  };

  lppl12 = {
    spdxId = "LPPL-1.2";
    fullName = "LaTeX Project Public License v1.2";
  };

  lppl13a = {
    spdxId = "LPPL-1.3a";
    fullName = "LaTeX Project Public License v1.3a";
  };

  lppl13c = {
    spdxId = "LPPL-1.3c";
    fullName = "LaTeX Project Public License v1.3c";
  };

  lpl-102 = {
    spdxId = "LPL-1.02";
    fullName = "Lucent Public License v1.02";
  };

  miros = {
    fullName = "MirOS License";
    url = "https://opensource.org/licenses/MirOS";
  };

  # spdx.org does not (yet) differentiate between the X11 and Expat versions
  # for details see https://en.wikipedia.org/wiki/MIT_License#Various_versions
  mit = {
    spdxId = "MIT";
    fullName = "MIT License";
  };
  # https://spdx.org/licenses/MIT-feh.html
  mit-feh = {
    spdxId = "MIT-feh";
    fullName = "feh License";
  };

  mitAdvertising = {
    spdxId = "MIT-advertising";
    fullName = "Enlightenment License (e16)";
  };

  mit0 = {
    spdxId = "MIT-0";
    fullName = "MIT No Attribution";
  };

  mpl10 = {
    spdxId = "MPL-1.0";
    fullName = "Mozilla Public License 1.0";
  };

  mpl11 = {
    spdxId = "MPL-1.1";
    fullName = "Mozilla Public License 1.1";
  };

  mpl20 = {
    spdxId = "MPL-2.0";
    fullName = "Mozilla Public License 2.0";
  };

  mspl = {
    spdxId = "MS-PL";
    fullName = "Microsoft Public License";
  };

  mulan-psl2 = {
    spdxId = "MulanPSL-2.0";
    fullName = "Mulan Permissive Software License, Version 2";
    url = "https://license.coscl.org.cn/MulanPSL2";
  };

  nasa13 = {
    spdxId = "NASA-1.3";
    fullName = "NASA Open Source Agreement 1.3";
    free = false;
  };

  ncsa = {
    spdxId = "NCSA";
    fullName = "University of Illinois/NCSA Open Source License";
  };

  nlpl = {
    spdxId = "NLPL";
    fullName = "No Limit Public License";
  };

  nposl3 = {
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

  odbl = {
    spdxId = "ODbL-1.0";
    fullName = "Open Data Commons Open Database License v1.0";
  };

  ofl = {
    spdxId = "OFL-1.1";
    fullName = "SIL Open Font License 1.1";
  };

  oml = {
    spdxId = "OML";
    fullName = "Open Market License";
  };

  openldap = {
    spdxId = "OLDAP-2.8";
    fullName = "Open LDAP Public License v2.8";
  };

  openssl = {
    spdxId = "OpenSSL";
    fullName = "OpenSSL License";
  };

  osl2 = {
    spdxId = "OSL-2.0";
    fullName = "Open Software License 2.0";
  };

  osl21 = {
    spdxId = "OSL-2.1";
    fullName = "Open Software License 2.1";
  };

  osl3 = {
    spdxId = "OSL-3.0";
    fullName = "Open Software License 3.0";
  };

  parity70 = {
    spdxId = "Parity-7.0.0";
    fullName = "Parity Public License 7.0.0";
    url = "https://paritylicense.com/versions/7.0.0.html";
  };

  php301 = {
    spdxId = "PHP-3.01";
    fullName = "PHP License v3.01";
  };

  postgresql = {
    spdxId = "PostgreSQL";
    fullName = "PostgreSQL License";
  };

  postman = {
    fullName = "Postman EULA";
    url = "https://www.getpostman.com/licenses/postman_base_app";
    free = false;
  };

  psfl = {
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

  prosperity30 = {
    fullName = "Prosperity-3.0.0";
    free = false;
    url = "https://prosperitylicense.com/versions/3.0.0.html";
  };

  qhull = {
    spdxId = "Qhull";
    fullName = "Qhull License";
  };

  qpl = {
    spdxId = "QPL-1.0";
    fullName = "Q Public License 1.0";
  };

  qwt = {
    fullName = "Qwt License, Version 1.0";
    url = "https://qwt.sourceforge.io/qwtlicense.html";
  };

  ruby = {
    spdxId = "Ruby";
    fullName = "Ruby License";
  };

  sendmail = {
    spdxId = "Sendmail";
    fullName = "Sendmail License";
  };

  sgi-b-20 = {
    spdxId = "SGI-B-2.0";
    fullName = "SGI Free Software License B v2.0";
  };

  # Gentoo seems to treat it as a license:
  # https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses/SGMLUG?id=7d999af4a47bf55e53e54713d98d145f935935c1
  sgmlug = {
    fullName = "SGML UG SGML Parser Materials license";
  };

  sleepycat = {
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
    # NOTE Debatable.
    # The license a slightly modified AGPL but still considered unfree by the
    # OSI for what seem like political reasons
    redistributable = true; # Definitely redistributable though, it's an AGPL derivative
  };

  stk = {
    shortName = "stk";
    fullName = "Synthesis Tool Kit 4.3";
    url = "https://github.com/thestk/stk/blob/master/LICENSE";
  };

  tsl = {
    shortName = "TSL";
    fullName = "Timescale License Agreegment";
    url = "https://github.com/timescale/timescaledb/blob/main/tsl/LICENSE-TIMESCALE";
    unfree = true;
  };

  tcltk = {
    spdxId = "TCL";
    fullName = "TCL/TK License";
  };

  ucd = {
    fullName = "Unicode Character Database License";
    url = "https://fedoraproject.org/wiki/Licensing:UCD";
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
    redistributable = true;
  };

  unfreeRedistributableFirmware = {
    fullName = "Unfree redistributable firmware";
    redistributable = true;
    # Note: we currently consider these "free" for inclusion in the
    # channel and NixOS images.
  };

  unicode-dfs-2015 = {
    spdxId = "Unicode-DFS-2015";
    fullName = "Unicode License Agreement - Data Files and Software (2015)";
  };

  unicode-dfs-2016 = {
    spdxId = "Unicode-DFS-2016";
    fullName = "Unicode License Agreement - Data Files and Software (2016)";
  };

  unlicense = {
    spdxId = "Unlicense";
    fullName = "The Unlicense";
  };

  upl = {
    fullName = "Universal Permissive License";
    url = "https://oss.oracle.com/licenses/upl/";
  };

  vim = {
    spdxId = "Vim";
    fullName = "Vim License";
  };

  virtualbox-puel = {
    fullName = "Oracle VM VirtualBox Extension Pack Personal Use and Evaluation License (PUEL)";
    url = "https://www.virtualbox.org/wiki/VirtualBox_PUEL";
    free = false;
  };

  vol-sl = {
    fullName = "Volatility Software License, Version 1.0";
    url = "https://www.volatilityfoundation.org/license/vsl-v1.0";
  };

  vsl10 = {
    spdxId = "VSL-1.0";
    fullName = "Vovida Software License v1.0";
  };

  watcom = {
    spdxId = "Watcom-1.0";
    fullName = "Sybase Open Watcom Public License 1.0";
  };

  w3c = {
    spdxId = "W3C";
    fullName = "W3C Software Notice and License";
  };

  wadalab = {
    fullName = "Wadalab Font License";
    url = "https://fedoraproject.org/wiki/Licensing:Wadalab?rd=Licensing/Wadalab";
  };

  wtfpl = {
    spdxId = "WTFPL";
    fullName = "Do What The F*ck You Want To Public License";
  };

  wxWindows = {
    spdxId = "wxWindows";
    fullName = "wxWindows Library Licence, Version 3.1";
  };

  x11 = {
    spdxId = "X11";
    fullName = "X11 License";
  };

  xfig = {
    fullName = "xfig";
    url = "http://mcj.sourceforge.net/authors.html#xfig"; # https is broken
  };

  zlib = {
    spdxId = "Zlib";
    fullName = "zlib License";
  };

  zpl20 = {
    spdxId = "ZPL-2.0";
    fullName = "Zope Public License 2.0";
  };

  zpl21 = {
    spdxId = "ZPL-2.1";
    fullName = "Zope Public License 2.1";
  };
} // {
  # TODO: remove legacy aliases
  agpl3 = {
    spdxId = "AGPL-3.0";
    fullName = "GNU Affero General Public License v3.0";
    deprecated = true;
  };
  gpl2 = {
    spdxId = "GPL-2.0";
    fullName = "GNU General Public License v2.0";
    deprecated = true;
  };
  gpl3 = {
    spdxId = "GPL-3.0";
    fullName = "GNU General Public License v3.0";
    deprecated = true;
  };
  lgpl2 = {
    spdxId = "LGPL-2.0";
    fullName = "GNU Library General Public License v2";
    deprecated = true;
  };
  lgpl21 = {
    spdxId = "LGPL-2.1";
    fullName = "GNU Lesser General Public License v2.1";
    deprecated = true;
  };
  lgpl3 = {
    spdxId = "LGPL-3.0";
    fullName = "GNU Lesser General Public License v3.0";
    deprecated = true;
  };
})
