/* List of NixOS maintainers.
    ```nix
    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";

      # Optional
      matrix = "@user:example.org";
      github = "GithubUsername";
      githubId = your-github-id;
      keys = [{
        longkeyid = "rsa2048/0x0123456789ABCDEF";
        fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
      }];
    };
    ```

    where

    - `handle` is the handle you are going to use in nixpkgs expressions,
    - `name` is your, preferably real, name,
    - `email` is your maintainer email address,
    - `matrix` is your Matrix user ID,
    - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
    - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
    - `keys` is a list of your PGP/GPG key IDs and fingerprints.

    `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.

    If `github` begins with a numeral, `handle` should be prefixed with an underscore.
    ```nix
    _1example = {
      github = "1example";
    };
    ```

    Add PGP/GPG keys only if you actually use them to sign commits and/or mail.

    To get the required PGP/GPG values for a key run
    ```shell
    gpg --keyid-format 0xlong --fingerprint <email> | head -n 2
    ```

    !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.

    More fields may be added in the future, however, in order to comply with GDPR this file should stay as minimal as possible.

    Please keep the list alphabetically sorted.
    See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.
*/
{
  _0qq = {
    email = "0qqw0qqw@gmail.com";
    github = "0qq";
    githubId = 64707304;
    name = "Dmitry Kulikov";
  };
  _0x4A6F = {
    email = "mail-maintainer@0x4A6F.dev";
    matrix = "@0x4a6f:matrix.org";
    name = "Joachim Ernst";
    github = "0x4A6F";
    githubId = 9675338;
    keys = [{
      longkeyid = "rsa8192/0x87027528B006D66D";
      fingerprint = "F466 A548 AD3F C1F1 8C88  4576 8702 7528 B006 D66D";
    }];
  };
  _0xbe7a = {
    email = "nix@be7a.de";
    name = "Bela Stoyan";
    github = "0xbe7a";
    githubId = 6232980;
    keys = [{
      longkeyid = "rsa4096/0x6510870A77F49A99";
      fingerprint = "2536 9E86 1AA5 9EB7 4C47  B138 6510 870A 77F4 9A99";
    }];
  };
  _1000101 = {
    email = "b1000101@pm.me";
    github = "1000101";
    githubId = 791309;
    name = "Jan Hrnko";
  };
  _1000teslas = {
    name = "Kevin Tran";
    email = "47207223+1000teslas@users.noreply.github.com";
    github = "1000teslas";
    githubId = 47207223;
  };
  _3699n = {
    email = "nicholas@nvk.pm";
    github = "3699n";
    githubId = 7414843;
    name = "Nicholas von Klitzing";
  };
  _13r0ck = {
    name = "Brock Szuszczewicz";
    email = "bnr@tuta.io";
    github = "13r0ck";
    githubId = 58987761;
  };
  _3noch = {
    email = "eacameron@gmail.com";
    github = "3noch";
    githubId = 882455;
    name = "Elliot Cameron";
  };
  _414owen = {
    email = "owen@owen.cafe";
    github = "414owen";
    githubId = 1714287;
    name = "Owen Shepherd";
  };
  _6AA4FD = {
    email = "f6442954@gmail.com";
    github = "6AA4FD";
    githubId = 12578560;
    name = "Quinn Bohner";
  };
  a1russell = {
    email = "adamlr6+pub@gmail.com";
    github = "a1russell";
    githubId = 241628;
    name = "Adam Russell";
  };
  aadibajpai = {
    email = "hello@aadibajpai.com";
    github = "aadibajpai";
    githubId = 27063113;
    name = "Aadi Bajpai";
  };
  aanderse = {
    email = "aaron@fosslib.net";
    matrix = "@aanderse:nixos.dev";
    github = "aanderse";
    githubId = 7755101;
    name = "Aaron Andersen";
  };
  aaronjanse = {
    email = "aaron@ajanse.me";
    matrix = "@aaronjanse:matrix.org";
    github = "aaronjanse";
    githubId = 16829510;
    name = "Aaron Janse";
  };
  aaronschif = {
    email = "aaronschif@gmail.com";
    github = "aaronschif";
    githubId = 2258953;
    name = "Aaron Schif";
  };
  aaschmid = {
    email = "service@aaschmid.de";
    github = "aaschmid";
    githubId = 567653;
    name = "Andreas Schmid";
  };
  abaldeau = {
    email = "andreas@baldeau.net";
    github = "baldo";
    githubId = 178750;
    name = "Andreas Baldeau";
  };
  abathur = {
    email = "travis.a.everett+nixpkgs@gmail.com";
    github = "abathur";
    githubId = 2548365;
    name = "Travis A. Everett";
  };
  abbe = {
    email = "ashish.is@lostca.se";
    matrix = "@abbe:badti.me";
    github = "wahjava";
    githubId = 2255192;
    name = "Ashish SHUKLA";
    keys = [{
      longkeyid = "rsa4096/0xC746CFA9E74FA4B0";
      fingerprint = "F682 CDCC 39DC 0FEA E116  20B6 C746 CFA9 E74F A4B0";
    }];
  };
  abbradar = {
    email = "ab@fmap.me";
    github = "abbradar";
    githubId = 1174810;
    name = "Nikolay Amiantov";
  };
  abhi18av = {
    email = "abhi18av@gmail.com";
    github = "abhi18av";
    githubId = 12799326;
    name = "Abhinav Sharma";
  };
  abigailbuccaneer = {
    email = "abigailbuccaneer@gmail.com";
    github = "abigailbuccaneer";
    githubId = 908758;
    name = "Abigail Bunyan";
  };
  aborsu = {
    email = "a.borsu@gmail.com";
    github = "aborsu";
    githubId = 5033617;
    name = "Augustin Borsu";
  };
  aboseley = {
    email = "adam.boseley@gmail.com";
    github = "aboseley";
    githubId = 13504599;
    name = "Adam Boseley";
  };
  abuibrahim = {
    email = "ruslan@babayev.com";
    github = "abuibrahim";
    githubId = 2321000;
    name = "Ruslan Babayev";
  };
  acairncross = {
    email = "acairncross@gmail.com";
    github = "acairncross";
    githubId = 1517066;
    name = "Aiken Cairncross";
  };
  aciceri = {
    name = "Andrea Ciceri";
    email = "andrea.ciceri@autistici.org";
    github = "aciceri";
    githubId = 2318843;
  };
  acowley = {
    email = "acowley@gmail.com";
    github = "acowley";
    githubId = 124545;
    name = "Anthony Cowley";
  };
  adamlwgriffiths = {
    email = "adam.lw.griffiths@gmail.com";
    github = "adamlwgriffiths";
    githubId = 1239156;
    name = "Adam Griffiths";
  };
  adamt = {
    email = "mail@adamtulinius.dk";
    github = "adamtulinius";
    githubId = 749381;
    name = "Adam Tulinius";
  };
  adelbertc = {
    email = "adelbertc@gmail.com";
    github = "adelbertc";
    githubId = 1332980;
    name = "Adelbert Chang";
  };
  adev = {
    email = "adev@adev.name";
    github = "adevress";
    githubId = 1773511;
    name = "Adrien Devresse";
  };
  addict3d = {
    email = "nickbathum@gmail.com";
    matrix = "@nbathum:matrix.org";
    github = "addict3d";
    githubId = 49227;
    name = "Nick Bathum";
  };
  adisbladis = {
    email = "adisbladis@gmail.com";
    matrix = "@adis:blad.is";
    github = "adisbladis";
    githubId = 63286;
    name = "Adam Hose";
  };
  Adjective-Object = {
    email = "mhuan13@gmail.com";
    github = "Adjective-Object";
    githubId = 1174858;
    name = "Maxwell Huang-Hobbs";
  };
  adnelson = {
    email = "ithinkican@gmail.com";
    github = "adnelson";
    githubId = 5091511;
    name = "Allen Nelson";
  };
  adolfogc = {
    email = "adolfo.garcia.cr@gmail.com";
    github = "adolfogc";
    githubId = 1250775;
    name = "Adolfo E. García Castro";
  };
  AdsonCicilioti = {
    name = "Adson Cicilioti";
    email = "adson.cicilioti@live.com";
    github = "AdsonCicilioti";
    githubId = 6278398;
  };
  adsr = {
    email = "as@php.net";
    github = "adsr";
    githubId = 315003;
    name = "Adam Saponara";
  };
  aerialx = {
    email = "aaron+nixos@aaronlindsay.com";
    github = "AerialX";
    githubId = 117295;
    name = "Aaron Lindsay";
  };
  aespinosa = {
    email = "allan.espinosa@outlook.com";
    github = "aespinosa";
    githubId = 58771;
    name = "Allan Espinosa";
  };
  aethelz = {
    email = "aethelz@protonmail.com";
    github = "aethelz";
    githubId = 10677343;
    name = "Eugene";
  };
  aflatter = {
    email = "flatter@fastmail.fm";
    github = "aflatter";
    githubId = 168;
    name = "Alexander Flatter";
  };
  afldcr = {
    email = "alex@fldcr.com";
    github = "afldcr";
    githubId = 335271;
    name = "James Alexander Feldman-Crough";
  };
  afontain = {
    email = "antoine.fontaine@epfl.ch";
    github = "necessarily-equal";
    githubId = 59283660;
    name = "Antoine Fontaine";
  };
  aforemny = {
    email = "aforemny@posteo.de";
    github = "aforemny";
    githubId = 610962;
    name = "Alexander Foremny";
  };
  afranchuk = {
    email = "alex.franchuk@gmail.com";
    github = "afranchuk";
    githubId = 4296804;
    name = "Alex Franchuk";
  };
  agbrooks = {
    email = "andrewgrantbrooks@gmail.com";
    github = "agbrooks";
    githubId = 19290901;
    name = "Andrew Brooks";
  };
  aherrmann = {
    email = "andreash87@gmx.ch";
    github = "aherrmann";
    githubId = 732652;
    name = "Andreas Herrmann";
  };
  ahrzb = {
    email = "ahrzb5@gmail.com";
    github = "ahrzb";
    githubId = 5220438;
    name = "AmirHossein Roozbahani";
  };
  ahuzik = {
    email = "ah1990au@gmail.com";
    github = "alesya-h";
    githubId = 209175;
    name = "Alesya Huzik";
  };
  aij = {
    email = "aij+git@mrph.org";
    github = "aij";
    githubId = 4732885;
    name = "Ivan Jager";
  };
  airwoodix = {
    email = "airwoodix@posteo.me";
    github = "airwoodix";
    githubId = 44871469;
    name = "Etienne Wodey";
  };
  ajs124 = {
    email = "nix@ajs124.de";
    matrix = "@andreas.schraegle:helsinki-systems.de";
    github = "ajs124";
    githubId = 1229027;
    name = "Andreas Schrägle";
  };
  ajgrf = {
    email = "a@ajgrf.com";
    github = "ajgrf";
    githubId = 10733175;
    name = "Alex Griffin";
  };
  ak = {
    email = "ak@formalprivacy.com";
    github = "alexanderkjeldaas";
    githubId = 339369;
    name = "Alexander Kjeldaas";
  };
  akavel = {
    email = "czapkofan@gmail.com";
    github = "akavel";
    githubId = 273837;
    name = "Mateusz Czapliński";
  };
  akamaus = {
    email = "dmitryvyal@gmail.com";
    github = "akamaus";
    githubId = 58955;
    name = "Dmitry Vyal";
  };
  akaWolf = {
    email = "akawolf0@gmail.com";
    github = "akaWolf";
    githubId = 5836586;
    name = "Artjom Vejsel";
  };
  akc = {
    email = "akc@akc.is";
    github = "akc";
    githubId = 1318982;
    name = "Anders Claesson";
  };
  akho = {
    name = "Alexander Khodyrev";
    email = "a@akho.name";
    github = "akho";
    githubId = 104951;
  };
  akru = {
    email = "mail@akru.me";
    github = "akru";
    githubId = 786394;
    name = "Alexander Krupenkin ";
  };
  akshgpt7 = {
    email = "akshgpt7@gmail.com";
    github = "akshgpt7";
    githubId = 20405311;
    name = "Aksh Gupta";
  };
  albakham = {
    email = "dev@geber.ga";
    github = "albakham";
    githubId = 43479487;
    name = "Titouan Biteau";
  };
  alerque = {
    email = "caleb@alerque.com";
    github = "alerque";
    githubId = 173595;
    name = "Caleb Maclennan";
  };
  ALEX11BR = {
    email = "alexioanpopa11@gmail.com";
    github = "ALEX11BR";
    githubId = 49609151;
    name = "Popa Ioan Alexandru";
  };
  alexarice = {
    email = "alexrice999@hotmail.co.uk";
    github = "alexarice";
    githubId = 17208985;
    name = "Alex Rice";
  };
  alexbakker = {
    email = "ab@alexbakker.me";
    github = "alexbakker";
    githubId = 2387841;
    name = "Alexander Bakker";
  };
  alexbiehl = {
    email = "alexbiehl@gmail.com";
    github = "alexbiehl";
    githubId = 1876617;
    name = "Alex Biehl";
  };
  alexchapman = {
    email = "alex@farfromthere.net";
    github = "AJChapman";
    githubId = 8316672;
    name = "Alex Chapman";
  };
  alexfmpe = {
    email = "alexandre.fmp.esteves@gmail.com";
    github = "alexfmpe";
    githubId = 2335822;
    name = "Alexandre Esteves";
  };
  alexnortung = {
    name = "alexnortung";
    email = "alex_nortung@live.dk";
    github = "alexnortung";
    githubId = 1552267;
  };
  alexvorobiev = {
    email = "alexander.vorobiev@gmail.com";
    github = "alexvorobiev";
    githubId = 782180;
    name = "Alex Vorobiev";
  };
  alex-eyre = {
    email = "A.Eyre@sms.ed.ac.uk";
    github = "alex-eyre";
    githubId = 38869148;
    name = "Alex Eyre";
  };
  alibabzo = {
    email = "alistair.bill@gmail.com";
    github = "alibabzo";
    githubId = 2822871;
    name = "Alistair Bill";
  };
  alirezameskin = {
    email = "alireza.meskin@gmail.com";
    github = "alirezameskin";
    githubId = 36147;
    name = "Alireza Meskin";
  };
  alkeryn = {
    email = "plbraundev@gmail.com";
    github = "Alkeryn";
    githubId = 11599075;
    name = "Pierre-Louis Braun";
  };
  all = {
    email = "nix-commits@lists.science.uu.nl";
    name = "Nix Committers";
  };
  allonsy = {
    email = "linuxbash8@gmail.com";
    github = "allonsy";
    githubId = 5892756;
    name = "Alec Snyder";
  };
  AluisioASG = {
    name = "Aluísio Augusto Silva Gonçalves";
    email = "aluisio@aasg.name";
    github = "AluisioASG";
    githubId = 1904165;
    keys = [{
      longkeyid = "rsa4096/0x9FAA63E097506D9D";
      fingerprint = "7FDB 17B3 C29B 5BA6 E5A9  8BB2 9FAA 63E0 9750 6D9D";
    }];
  };
  almac = {
    email = "alma.cemerlic@gmail.com";
    github = "a1mac";
    githubId = 60479013;
    name = "Alma Cemerlic";
  };
  alunduil = {
    email = "alunduil@gmail.com";
    github = "alunduil";
    githubId = 169249;
    name = "Alex Brandt";
  };
  alva = {
    email = "alva@skogen.is";
    github = "fjallarefur";
    githubId = 42881386;
    name = "Alva";
    keys = [{
      longkeyid = "ed25519/0xF53E323342F7A6D3";
      fingerprint = "B422 CFB1 C9EF 73F7 E1E2 698D F53E 3233 42F7 A6D3A";
    }];
  };
  alyaeanyx = {
    email = "alexandra.hollmeier@mailbox.org";
    github = "alyaeanyx";
    githubId = 74795488;
    name = "Alexandra Hollmeier";
    keys = [{
      longkeyid = "rsa3072/0x87D1AADCD25B8DEE";
      fingerprint = "1F73 8879 5E5A 3DFC E2B3 FA32 87D1 AADC D25B 8DEE";
    }];
  };
  amanjeev = {
    email = "aj@amanjeev.com";
    github = "amanjeev";
    githubId = 160476;
    name = "Amanjeev Sethi";
  };
  amar1729 = {
    email = "amar.paul16@gmail.com";
    github = "amar1729";
    githubId = 15623522;
    name = "Amar Paul";
  };
  ambroisie = {
    email = "bruno.nixpkgs@belanyi.fr";
    github = "ambroisie";
    githubId = 12465195;
    name = "Bruno BELANYI";
  };
  ambrop72 = {
    email = "ambrop7@gmail.com";
    github = "ambrop72";
    githubId = 2626481;
    name = "Ambroz Bizjak";
  };
  ametrine = {
    name = "Matilde Ametrine";
    email = "matilde@diffyq.xyz";
    github = "matilde-ametrine";
    githubId = 90799677;
    keys = [{
      longkeyid = "rsa3072/0x07EE1FFCA58A11C5";
      fingerprint = "7931 EB4E 4712 D7BE 04F8  6D34 07EE 1FFC A58A 11C5";
    }];
  };
  amfl = {
    email = "amfl@none.none";
    github = "amfl";
    githubId = 382798;
    name = "amfl";
  };
  amiddelk = {
    email = "amiddelk@gmail.com";
    github = "amiddelk";
    githubId = 1358320;
    name = "Arie Middelkoop";
  };
  amiloradovsky = {
    email = "miloradovsky@gmail.com";
    github = "amiloradovsky";
    githubId = 20530052;
    name = "Andrew Miloradovsky";
  };
  notbandali = {
    name = "Amin Bandali";
    email = "bandali@gnu.org";
    github = "notbandali";
    githubId = 1254858;
    keys = [{
      longkeyid = "rsa4096/0xA21A020248816103";
      fingerprint = "BE62 7373 8E61 6D6D 1B3A  08E8 A21A 0202 4881 6103";
    }];
  };
  aminechikhaoui = {
    email = "amine.chikhaoui91@gmail.com";
    github = "AmineChikhaoui";
    githubId = 5149377;
    name = "Amine Chikhaoui";
  };
  amorsillo = {
    email = "andrew.morsillo@gmail.com";
    github = "AndrewMorsillo";
    githubId = 858965;
    name = "Andrew Morsillo";
  };
  andehen = {
    email = "git@andehen.net";
    github = "andehen";
    githubId = 754494;
    name = "Anders Asheim Hennum";
  };
  andersk = {
    email = "andersk@mit.edu";
    github = "andersk";
    githubId = 26471;
    name = "Anders Kaseorg";
  };
  anderslundstedt = {
    email = "git@anderslundstedt.se";
    github = "anderslundstedt";
    githubId = 4514101;
    name = "Anders Lundstedt";
  };
  AndersonTorres = {
    email = "torres.anderson.85@protonmail.com";
    github = "AndersonTorres";
    githubId = 5954806;
    name = "Anderson Torres";
  };
  anderspapitto = {
    email = "anderspapitto@gmail.com";
    github = "anderspapitto";
    githubId = 1388690;
    name = "Anders Papitto";
  };
  andir = {
    email = "andreas@rammhold.de";
    github = "andir";
    githubId = 638836;
    name = "Andreas Rammhold";
  };
  andreasfelix = {
    email = "fandreas@physik.hu-berlin.de";
    github = "andreasfelix";
    githubId = 24651767;
    name = "Felix Andreas";
  };
  andres = {
    email = "ksnixos@andres-loeh.de";
    github = "kosmikus";
    githubId = 293191;
    name = "Andres Loeh";
  };
  andresilva = {
    email = "andre.beat@gmail.com";
    github = "andresilva";
    githubId = 123550;
    name = "André Silva";
  };
  andrestylianos = {
    email = "andre.stylianos@gmail.com";
    github = "andrestylianos";
    githubId = 7112447;
    name = "Andre S. Ramos";
  };
  andrew-d = {
    email = "andrew@du.nham.ca";
    github = "andrew-d";
    githubId = 1079173;
    name = "Andrew Dunham";
  };
  andrewchambers = {
    email = "ac@acha.ninja";
    github = "andrewchambers";
    githubId = 962885;
    name = "Andrew Chambers";
  };
  andrewrk = {
    email = "superjoe30@gmail.com";
    github = "andrewrk";
    githubId = 106511;
    name = "Andrew Kelley";
  };
  andsild = {
    email = "andsild@gmail.com";
    github = "andsild";
    githubId = 3808928;
    name = "Anders Sildnes";
  };
  andys8 = {
    email = "andys8@users.noreply.github.com";
    github = "andys8";
    githubId = 13085980;
    name = "Andy";
  };
  aneeshusa = {
    email = "aneeshusa@gmail.com";
    github = "aneeshusa";
    githubId = 2085567;
    name = "Aneesh Agrawal";
  };
  angristan = {
    email = "angristan@pm.me";
    github = "angristan";
    githubId = 11699655;
    name = "Stanislas Lange";
  };
  angustrau = {
    name = "Angus Trau";
    email = "nix@angus.ws";
    matrix = "@angustrau:matrix.org";
    github = "angustrau";
    githubId = 13267947;
  };
  anhdle14 = {
    name = "Le Anh Duc";
    email = "anhdle14@icloud.com";
    github = "anhdle14";
    githubId = 9645992;
    keys = [{
      longkeyid = "rsa4096/0x0299AFF9ECBB5169";
      fingerprint = "AA4B 8EC3 F971 D350 482E  4E20 0299 AFF9 ECBB 5169";
    }];
  };
  anhduy = {
    email = "vo@anhduy.io";
    github = "voanhduy1512";
    githubId = 1771266;
    name = "Vo Anh Duy";
  };
  anirrudh = {
    email = "anik597@gmail.com";
    github = "anirrudh";
    githubId = 6091755;
    name = "Anirrudh Krishnan";
  };
  ankhers = {
    email = "me@ankhers.dev";
    github = "ankhers";
    githubId = 750786;
    name = "Justin Wood";
  };
  anna328p = {
    email = "anna328p@gmail.com";
    github = "anna328p";
    githubId = 9790772;
    name = "Anna";
  };
  anmonteiro = {
    email = "anmonteiro@gmail.com";
    github = "anmonteiro";
    githubId = 661909;
    name = "Antonio Nuno Monteiro";
  };
  anpryl = {
    email = "anpryl@gmail.com";
    github = "anpryl";
    githubId = 5327697;
    name = "Anatolii Prylutskyi";
  };
  antoinerg = {
    email = "roygobeil.antoine@gmail.com";
    github = "antoinerg";
    githubId = 301546;
    name = "Antoine Roy-Gobeil";
  };
  anton-dessiatov = {
    email = "anton.dessiatov@gmail.com";
    github = "anton-dessiatov";
    githubId = 2873280;
    name = "Anton Desyatov";
  };
  Anton-Latukha = {
    email = "anton.latuka+nixpkgs@gmail.com";
    github = "Anton-Latukha";
    githubId = 20933385;
    name = "Anton Latukha";
  };
  antono = {
    email = "self@antono.info";
    github = "antono";
    githubId = 7622;
    name = "Antono Vasiljev";
  };
  antonxy = {
    email = "anton.schirg@posteo.de";
    github = "antonxy";
    githubId = 4194320;
    name = "Anton Schirg";
  };
  apeschar = {
    email = "albert@peschar.net";
    github = "apeschar";
    githubId = 122977;
    name = "Albert Peschar";
  };
  apeyroux = {
    email = "alex@px.io";
    github = "apeyroux";
    githubId = 1078530;
    name = "Alexandre Peyroux";
  };
  applePrincess = {
    email = "appleprincess@appleprincess.io";
    github = "applePrincess";
    githubId = 17154507;
    name = "Lein Matsumaru";
    keys = [{
      longkeyid = "rsa4096/0xAAA50652F0479205";
      fingerprint = "BF8B F725 DA30 E53E 7F11  4ED8 AAA5 0652 F047 9205";
    }];
  };
  ar1a = {
    email = "aria@ar1as.space";
    github = "ar1a";
    githubId = 8436007;
    name = "Aria Edmonds";
  };
  arcadio = {
    email = "arc@well.ox.ac.uk";
    github = "arcadio";
    githubId = 56009;
    name = "Arcadio Rubio García";
  };
  archseer = {
    email = "blaz@mxxn.io";
    github = "archseer";
    githubId = 1372918;
    name = "Blaž Hrastnik";
  };
  arcnmx = {
    email = "arcnmx@users.noreply.github.com";
    github = "arcnmx";
    githubId = 13426784;
    name = "arcnmx";
  };
  arcticlimer = {
    email = "vinigm.nho@gmail.com";
    github = "arcticlimer";
    githubId = 59743220;
    name = "Vinícius Müller";
  };
  ardumont = {
    email = "eniotna.t@gmail.com";
    github = "ardumont";
    githubId = 718812;
    name = "Antoine R. Dumont";
  };
  arezvov = {
    email = "alex@rezvov.ru";
    github = "arezvov";
    githubId = 58516559;
    name = "Alexander Rezvov";
  };
  arianvp = {
    email = "arian.vanputten@gmail.com";
    github = "arianvp";
    githubId = 628387;
    name = "Arian van Putten";
  };
  aristid = {
    email = "aristidb@gmail.com";
    github = "aristidb";
    githubId = 30712;
    name = "Aristid Breitkreuz";
  };
  ariutta = {
    email = "anders.riutta@gmail.com";
    github = "ariutta";
    githubId = 1296771;
    name = "Anders Riutta";
  };
  arkivm = {
    email = "vikram186@gmail.com";
    github = "arkivm";
    githubId = 1118815;
    name = "Vikram Narayanan";
  };
  armijnhemel = {
    email = "armijn@tjaldur.nl";
    github = "armijnhemel";
    githubId = 10587952;
    name = "Armijn Hemel";
  };
  arnarg = {
    email = "arnarg@fastmail.com";
    github = "arnarg";
    githubId = 1291396;
    name = "Arnar Ingason";
  };
  arnoldfarkas = {
    email = "arnold.farkas@gmail.com";
    github = "arnoldfarkas";
    githubId = 59696216;
    name = "Arnold Farkas";
  };
  arnoutkroeze = {
    email = "nixpkgs@arnoutkroeze.nl";
    github = "arnoutkroeze";
    githubId = 37151054;
    name = "Arnout Kroeze";
  };
  arobyn = {
    email = "shados@shados.net";
    github = "shados";
    githubId = 338268;
    name = "Alexei Robyn";
  };
  artemist = {
    email = "me@artem.ist";
    github = "artemist";
    githubId = 1226638;
    name = "Artemis Tosini";
    keys = [{
      longkeyid = "rsa4096/0x4FDC96F161E7BA8A";
      fingerprint = "3D2B B230 F9FA F0C5 1832  46DD 4FDC 96F1 61E7 BA8A";
    }];
  };
  arthur = {
    email = "me@arthur.li";
    github = "arthurl";
    githubId = 3965744;
    name = "Arthur Lee";
  };
  arthurteisseire = {
    email = "arthurteisseire33@gmail.com";
    github = "arthurteisseire";
    githubId = 37193992;
    name = "Arthur Teisseire";
  };
  arturcygan = {
    email = "arczicygan@gmail.com";
    github = "arcz";
    githubId = 4679721;
    name = "Artur Cygan";
  };
  artuuge = {
    email = "artuuge@gmail.com";
    github = "artuuge";
    githubId = 10285250;
    name = "Artur E. Ruuge";
  };
  asbachb = {
    email = "asbachb-nixpkgs-5c2a@impl.it";
    matrix = "@asbachb:matrix.org";
    github = "asbachb";
    githubId = 1482768;
    name = "Benjamin Asbach";
  };
  ashalkhakov = {
    email = "artyom.shalkhakov@gmail.com";
    github = "ashalkhakov";
    githubId = 1270502;
    name = "Artyom Shalkhakov";
  };
  ashgillman = {
    email = "gillmanash@gmail.com";
    github = "ashgillman";
    githubId = 816777;
    name = "Ashley Gillman";
  };
  ashkitten = {
    email = "ashlea@protonmail.com";
    github = "ashkitten";
    githubId = 9281956;
    name = "ash lea";
  };
  aske = {
    email = "aske@fmap.me";
    github = "aske";
    githubId = 869771;
    name = "Kirill Boltaev";
  };
  ashley = {
    email = "personavinny@protonmail.com";
    github = "paranoidcat";
    githubId = 84152630;
    name = "Ashley Chiara";
  };
  asppsa = {
    email = "asppsa@gmail.com";
    github = "asppsa";
    githubId = 453170;
    name = "Alastair Pharo";
  };
  astro = {
    email = "astro@spaceboyz.net";
    github = "astro";
    githubId = 12923;
    name = "Astro";
  };
  astsmtl = {
    email = "astsmtl@yandex.ru";
    github = "astsmtl";
    githubId = 2093941;
    name = "Alexander Tsamutali";
  };
  asymmetric = {
    email = "lorenzo@mailbox.org";
    github = "asymmetric";
    githubId = 101816;
    name = "Lorenzo Manacorda";
  };
  aszlig = {
    email = "aszlig@nix.build";
    github = "aszlig";
    githubId = 192147;
    name = "aszlig";
    keys = [{
      longkeyid = "ed25519/0x684089CE67EBB691";
      fingerprint = "DD52 6BC7 767D BA28 16C0 95E5 6840 89CE 67EB B691";
    }];
  };
  atemu = {
    name = "Atemu";
    email = "atemu.main+nixpkgs@gmail.com";
    github = "Atemu";
    githubId = 18599032;
  };
  athas = {
    email = "athas@sigkill.dk";
    github = "athas";
    githubId = 55833;
    name = "Troels Henriksen";
  };
  atkinschang = {
    email = "atkinschang+nixpkgs@gmail.com";
    github = "AtkinsChang";
    githubId = 5193600;
    name = "Atkins Chang";
  };
  atnnn = {
    email = "etienne@atnnn.com";
    github = "atnnn";
    githubId = 706854;
    name = "Etienne Laurin";
  };
  attila-lendvai = {
    name = "Attila Lendvai";
    email = "attila@lendvai.name";
    github = "attila-lendvai";
    githubId = 840345;
  };
  auntie = {
    email = "auntieNeo@gmail.com";
    github = "auntieNeo";
    githubId = 574938;
    name = "Jonathan Glines";
  };
  austinbutler = {
    email = "austinabutler@gmail.com";
    github = "austinbutler";
    githubId = 354741;
    name = "Austin Butler";
  };
  autophagy = {
    email = "mail@autophagy.io";
    github = "autophagy";
    githubId = 12958979;
    name = "Mika Naylor";
  };
  avaq = {
    email = "nixpkgs@account.avaq.it";
    github = "avaq";
    githubId = 1217745;
    name = "Aldwin Vlasblom";
  };
  avery = {
    email = "averyl+nixos@protonmail.com";
    github = "AveryLychee";
    githubId = 9147625;
    name = "Avery Lychee";
  };
  averelld = {
    email = "averell+nixos@rxd4.com";
    github = "averelld";
    githubId = 687218;
    name = "averelld";
  };
  avh4 = {
    email = "gruen0aermel@gmail.com";
    github = "avh4";
    githubId = 1222;
    name = "Aaron VonderHaar";
  };
  avitex = {
    email = "theavitex@gmail.com";
    github = "avitex";
    githubId = 5110816;
    name = "avitex";
    keys = [{
      longkeyid = "rsa4096/0x8B366C443CABE942";
      fingerprint = "271E 136C 178E 06FA EA4E  B854 8B36 6C44 3CAB E942";
    }];
  };
  avnik = {
    email = "avn@avnik.info";
    github = "avnik";
    githubId = 153538;
    name = "Alexander V. Nikolaev";
  };
  aw = {
    email = "aw-nixos@meterriblecrew.net";
    github = "herrwiese";
    githubId = 206242;
    name = "Andreas Wiese";
  };
  aycanirican = {
    email = "iricanaycan@gmail.com";
    github = "aycanirican";
    githubId = 135230;
    name = "Aycan iRiCAN";
  };
  arjix = {
    email = "arjix@protonmail.com";
    github = "arjix";
    githubId = 62168569;
    name = "arjix";
  };
  artturin = {
    email = "artturin@artturin.com";
    matrix = "@artturin:matrix.org";
    github = "artturin";
    githubId = 56650223;
    name = "Artturi N";
  };
  azahi = {
    email = "azahi@teknik.io";
    matrix = "@azahi:matrix.org";
    github = "azahi";
    githubId = 22211000;
    name = "Azat Bahawi";
    keys = [{
      longkeyid = "rsa2048/0xB40FCB6608BBE3B6";
      fingerprint = "E9F3 483F 31C7 29B4 4CA2  7C38 B40F CB66 08BB E3B6";
    }];
  };
  ayazhafiz = {
    email = "ayaz.hafiz.1@gmail.com";
    github = "ayazhafiz";
    githubId = 262763;
    name = "Ayaz Hafiz";
  };
  b4dm4n = {
    email = "fabianm88@gmail.com";
    github = "B4dM4n";
    githubId = 448169;
    name = "Fabian Möller";
    keys = [{
      longkeyid = "rsa4096/0x754B5C0963C42C5";
      fingerprint = "6309 E212 29D4 DA30 AF24  BDED 754B 5C09 63C4 2C50";
    }];
  };
  babariviere = {
    email = "babathriviere@gmail.com";
    github = "babariviere";
    githubId = 12128029;
    name = "Bastien Rivière";
    keys = [{
      longkeyid = "rsa4096/0xF202AD3B6EDF4BD1";
      fingerprint = "2F85 B362 B274 0012 37E2  81EE F202 AD3B 6EDF 4BD1";
    }];
  };
  babbaj = {
    name = "babbaj";
    email = "babbaj45@gmail.com";
    github = "babbaj";
    githubId = 12820770;
    keys = [{
      longkeyid = "rsa4096/0xF044309848A07CAC";
      fingerprint = "6FBC A462 4EAF C69C A7C4  98C1 F044 3098 48A0 7CAC";
    }];
  };
  bachp = {
    email = "pascal.bach@nextrem.ch";
    matrix = "@bachp:matrix.org";
    github = "bachp";
    githubId = 333807;
    name = "Pascal Bach";
  };
  backuitist = {
    email = "biethb@gmail.com";
    github = "backuitist";
    githubId = 1017537;
    name = "Bruno Bieth";
  };
  badmutex = {
    email = "github@badi.sh";
    github = "badmutex";
    githubId = 35324;
    name = "Badi' Abdul-Wahid";
  };
  balajisivaraman = {
    email = "sivaraman.balaji@gmail.com";
    name = "Balaji Sivaraman";
  };
  balodja = {
    email = "balodja@gmail.com";
    github = "balodja";
    githubId = 294444;
    name = "Vladimir Korolev";
  };
  baloo = {
    email = "nixpkgs@superbaloo.net";
    github = "baloo";
    githubId = 59060;
    name = "Arthur Gautier";
  };
  balsoft = {
    email = "balsoft75@gmail.com";
    github = "balsoft";
    githubId = 18467667;
    name = "Alexander Bantyev";
  };
  bandresen = {
    email = "bandresen@gmail.com";
    github = "bandresen";
    githubId = 80325;
    name = "Benjamin Andresen";
  };
  baracoder = {
    email = "baracoder@googlemail.com";
    github = "baracoder";
    githubId = 127523;
    name = "Herman Fries";
  };
  barrucadu = {
    email = "mike@barrucadu.co.uk";
    github = "barrucadu";
    githubId = 75235;
    name = "Michael Walker";
  };
  bartuka = {
    email = "wand@hey.com";
    github = "wandersoncferreira";
    githubId = 17708295;
    name = "Wanderson Ferreira";
    keys = [{
      longkeyid = "rsa4096/0x56840A614DBE37AE";
      fingerprint = "A3E1 C409 B705 50B3 BF41  492B 5684 0A61 4DBE 37AE";
    }];
  };
  basvandijk = {
    email = "v.dijk.bas@gmail.com";
    github = "basvandijk";
    githubId = 576355;
    name = "Bas van Dijk";
  };
  Baughn = {
    email = "sveina@gmail.com";
    github = "Baughn";
    githubId = 45811;
    name = "Svein Ove Aas";
  };
  bb010g = {
    email = "me@bb010g.com";
    matrix = "@bb010g:matrix.org";
    github = "bb010g";
    githubId = 340132;
    name = "Brayden Banks";
  };
  bbarker = {
    email = "brandon.barker@gmail.com";
    github = "bbarker";
    githubId = 916366;
    name = "Brandon Elam Barker";
  };
  bbigras = {
    email = "bigras.bruno@gmail.com";
    github = "bbigras";
    githubId = 24027;
    name = "Bruno Bigras";
  };
  bcarrell = {
    email = "brandoncarrell@gmail.com";
    github = "bcarrell";
    githubId = 1015044;
    name = "Brandon Carrell";
  };
  bcc32 = {
    email = "me@bcc32.com";
    github = "bcc32";
    githubId = 1239097;
    name = "Aaron Zeng";
  };
  bcdarwin = {
    email = "bcdarwin@gmail.com";
    github = "bcdarwin";
    githubId = 164148;
    name = "Ben Darwin";
  };
  bdesham = {
    email = "benjamin@esham.io";
    github = "bdesham";
    githubId = 354230;
    name = "Benjamin Esham";
  };
  bdimcheff = {
    email = "brandon@dimcheff.com";
    github = "bdimcheff";
    githubId = 14111;
    name = "Brandon Dimcheff";
  };
  beardhatcode = {
    name = "Robbert Gurdeep Singh";
    email = "nixpkgs@beardhatcode.be";
    github = "beardhatcode";
    githubId = 662538;
  };
  beezow = {
    name = "beezow";
    email = "zbeezow@gmail.com";
    github = "beezow";
    githubId = 42082156;
  };
  bendlas = {
    email = "herwig@bendlas.net";
    matrix = "@bendlas:matrix.org";
    github = "bendlas";
    githubId = 214787;
    name = "Herwig Hochleitner";
  };
  benley = {
    email = "benley@gmail.com";
    github = "benley";
    githubId = 1432730;
    name = "Benjamin Staffin";
  };
  benneti = {
    name = "Benedikt Tissot";
    email = "benedikt.tissot@googlemail.com";
    github = "benneti";
    githubId = 11725645;
  };
  bertof = {
    name = "Filippo Berto";
    email = "berto.f@protonmail.com";
    github = "bertof";
    githubId = 9915675;
    keys = [{
      longkeyid = "rsa4096/0xFE98AE5EC52B1056";
      fingerprint = "17C5 1EF9 C0FE 2EB2 FE56  BB53 FE98 AE5E C52B 1056";
    }];
  };
  bennofs = {
    email = "benno.fuenfstueck@gmail.com";
    github = "bennofs";
    githubId = 3192959;
    name = "Benno Fünfstück";
  };
  benpye = {
    email = "ben@curlybracket.co.uk";
    github = "benpye";
    githubId = 442623;
    name = "Ben Pye";
  };
  benwbooth = {
    email = "benwbooth@gmail.com";
    github = "benwbooth";
    githubId = 75972;
    name = "Ben Booth";
  };
  berberman = {
    email = "berberman@yandex.com";
    matrix = "@berberman:mozilla.org";
    github = "berberman";
    githubId = 26041945;
    name = "Potato Hatsue";
  };
  berce = {
    email = "bert.moens@gmail.com";
    github = "berce";
    githubId = 10439709;
    name = "Bert Moens";
  };
  berdario = {
    email = "berdario@gmail.com";
    github = "berdario";
    githubId = 752835;
    name = "Dario Bertini";
  };
  bergey = {
    email = "bergey@teallabs.org";
    github = "bergey";
    githubId = 251106;
    name = "Daniel Bergey";
  };
  bergkvist = {
    email = "tobias@bergkv.ist";
    github = "bergkvist";
    githubId = 410028;
    name = "Tobias Bergkvist";
  };
  betaboon = {
    email = "betaboon@0x80.ninja";
    github = "betaboon";
    githubId = 7346933;
    name = "betaboon";
  };
  bew = {
    email = "benoit.dechezelles@gmail.com";
    github = "bew";
    githubId = 9730330;
    name = "Benoit de Chezelles";
  };
  bfortz = {
    email = "bernard.fortz@gmail.com";
    github = "bfortz";
    githubId = 16426882;
    name = "Bernard Fortz";
  };
  bgamari = {
    email = "ben@smart-cactus.org";
    github = "bgamari";
    githubId = 1010174;
    name = "Ben Gamari";
  };
  bhall = {
    email = "brendan.j.hall@bath.edu";
    github = "brendan-hall";
    githubId = 34919100;
    name = "Brendan Hall";
  };
  bhipple = {
    email = "bhipple@protonmail.com";
    github = "bhipple";
    githubId = 2071583;
    name = "Benjamin Hipple";
  };
  bhougland = {
    email = "benjamin.hougland@gmail.com";
    github = "bhougland18";
    githubId = 28444296;
    name = "Benjamin Hougland";
  };
  billewanick = {
    email = "bill@ewanick.com";
    github = "billewanick";
    githubId = 13324165;
    name = "Bill Ewanick";
  };
  binarin = {
    email = "binarin@binarin.ru";
    github = "binarin";
    githubId = 185443;
    name = "Alexey Lebedeff";
  };
  bjg = {
    email = "bjg@gnu.org";
    name = "Brian Gough";
  };
  bjornfor = {
    email = "bjorn.forsman@gmail.com";
    github = "bjornfor";
    githubId = 133602;
    name = "Bjørn Forsman";
  };
  bkchr = {
    email = "nixos@kchr.de";
    github = "bkchr";
    githubId = 5718007;
    name = "Bastian Köcher";
  };
  blaggacao = {
    name = "David Arnold";
    email = "dar@xoe.solutions";
    github = "blaggacao";
    githubId = 7548295;
  };
  blanky0230 = {
    email = "blanky0230@gmail.com";
    github = "blanky0230";
    githubId = 5700358;
    name = "Thomas Blank";
  };
  blitz = {
    email = "js@alien8.de";
    matrix = "@js:ukvly.org";
    github = "blitz";
    githubId = 37907;
    name = "Julian Stecklina";
  };
  bloomvdomino = {
    name = "Laura Fäßler";
    email = "0x@ytex.de";
    github = "bloomvdomino";
    githubId = 33204710;
  };
  bluescreen303 = {
    email = "mathijs@bluescreen303.nl";
    github = "bluescreen303";
    githubId = 16330;
    name = "Mathijs Kwik";
  };
  bmilanov = {
    name = "Biser Milanov";
    email = "bmilanov11+nixpkgs@gmail.com";
    github = "bmilanov";
    githubId = 30090366;
  };
  bmwalters = {
    name = "Bradley Walters";
    email = "oss@walters.app";
    github = "bmwalters";
    githubId = 4380777;
  };
  bobakker = {
    email = "bobakk3r@gmail.com";
    github = "bobakker";
    githubId = 10221570;
    name = "Bo Bakker";
  };
  bobby285271 = {
    name = "Bobby Rong";
    email = "rjl931189261@126.com";
    matrix = "@bobby285271:matrix.org";
    github = "bobby285271";
    githubId = 20080233;
  };
  bobvanderlinden = {
    email = "bobvanderlinden@gmail.com";
    github = "bobvanderlinden";
    githubId = 6375609;
    name = "Bob van der Linden";
  };
  bodil = {
    email = "nix@bodil.org";
    github = "bodil";
    githubId = 17880;
    name = "Bodil Stokke";
  };
  boj = {
    email = "brian@uncannyworks.com";
    github = "boj";
    githubId = 50839;
    name = "Brian Jones";
  };
  bootstrap-prime = {
    email = "bootstrap.prime@gmail.com";
    github = "bootstrap-prime";
    githubId = 68566724;
    name = "bootstrap-prime";
  };
  commandodev = {
    email = "ben@perurbis.com";
    github = "commandodev";
    githubId = 87764;
    name = "Ben Ford";
  };
  boppyt = {
    email = "boppy@nwcpz.com";
    github = "boppyt";
    githubId = 71049646;
    name = "Zack A";
    keys = [{
      longkeyid = "rsa4096/0x6310C97DE31D1545";
      fingerprint = "E8D7 5C19 9F65 269B 439D  F77B 6310 C97D E31D 1545";
    }];
  };
  borisbabic = {
    email = "boris.ivan.babic@gmail.com";
    github = "borisbabic";
    githubId = 1743184;
    name = "Boris Babić";
  };
  bosu = {
    email = "boriss@gmail.com";
    github = "bosu";
    githubId = 3465841;
    name = "Boris Sukholitko";
  };
  bouk = {
    name = "Bouke van der Bijl";
    email = "i@bou.ke";
    github = "bouk";
    githubId = 97820;
  };
  bradediger = {
    email = "brad@bradediger.com";
    github = "bradediger";
    githubId = 4621;
    name = "Brad Ediger";
  };
  brainrape = {
    email = "martonboros@gmail.com";
    github = "brainrape";
    githubId = 302429;
    name = "Marton Boros";
  };
  bramd = {
    email = "bram@bramd.nl";
    github = "bramd";
    githubId = 86652;
    name = "Bram Duvigneau";
  };
  braydenjw = {
    email = "nixpkgs@willenborg.ca";
    github = "braydenjw";
    githubId = 2506621;
    name = "Brayden Willenborg";
  };
  brian-dawn = {
    email = "brian.t.dawn@gmail.com";
    github = "brian-dawn";
    githubId = 1274409;
    name = "Brian Dawn";
  };
  brianhicks = {
    email = "brian@brianthicks.com";
    github = "BrianHicks";
    githubId = 355401;
    name = "Brian Hicks";
  };
  Br1ght0ne = {
    email = "brightone@protonmail.com";
    github = "Br1ght0ne";
    githubId = 12615679;
    name = "Oleksii Filonenko";
    keys = [{
      longkeyid = "rsa3072/0xA1BC8428323ECFE8";
      fingerprint = "F549 3B7F 9372 5578 FDD3  D0B8 A1BC 8428 323E CFE8";
    }];
  };
  bsima = {
    email = "ben@bsima.me";
    github = "bsima";
    githubId = 200617;
    name = "Ben Sima";
  };
  bstrik = {
    email = "dutchman55@gmx.com";
    github = "bstrik";
    githubId = 7716744;
    name = "Berno Strik";
  };
  breakds = {
    email = "breakds@gmail.com";
    github = "breakds";
    githubId = 1111035;
    name = "Break Yang";
  };
  brecht = {
    email = "brecht.savelkoul@alumni.lse.ac.uk";
    github = "brechtcs";
    githubId = 6107054;
    name = "Brecht Savelkoul";
  };
  brettlyons = {
    email = "blyons@fastmail.com";
    github = "brettlyons";
    githubId = 3043718;
    name = "Brett Lyons";
  };
  brodes = {
    email = "me@brod.es";
    github = "brhoades";
    githubId = 4763746;
    name = "Billy Rhoades";
    keys = [{
      longkeyid = "rsa4096/0x8AE74787A4B7C07E";
      fingerprint = "BF4FCB85C69989B4ED95BF938AE74787A4B7C07E";
    }];
  };
  broke = {
    email = "broke@in-fucking.space";
    github = "broke";
    githubId = 1071610;
    name = "Gunnar Nitsche";
  };
  bryanasdev000 = {
    email = "bryanasdev000@gmail.com";
    matrix = "@bryanasdev000:matrix.org";
    github = "bryanasdev000";
    githubId = 53131727;
    name = "Bryan Albuquerque";
  };
  btlvr = {
    email = "btlvr@protonmail.com";
    github = "btlvr";
    githubId = 32319131;
    name = "Brett L";
  };
  buckley310 = {
    email = "sean.bck@gmail.com";
    matrix = "@buckley310:matrix.org";
    github = "buckley310";
    githubId = 2379774;
    name = "Sean Buckley";
  };
  buffet = {
    email = "niclas@countingsort.com";
    github = "buffet";
    githubId = 33751841;
    name = "Niclas Meyer";
  };
  bugworm = {
    email = "bugworm@zoho.com";
    github = "bugworm";
    githubId = 7214361;
    name = "Roman Gerasimenko";
  };
  bburdette = {
    email = "bburdette@protonmail.com";
    github = "bburdette";
    githubId = 157330;
    name = "Ben Burdette";
  };
  bzizou = {
    email = "Bruno@bzizou.net";
    github = "bzizou";
    githubId = 2647566;
    name = "Bruno Bzeznik";
  };
  c0bw3b = {
    email = "c0bw3b@gmail.com";
    github = "c0bw3b";
    githubId = 24417923;
    name = "Renaud";
  };
  c00w = {
    email = "nix@daedrum.net";
    github = "c00w";
    githubId = 486199;
    name = "Colin";
  };
  c0deaddict = {
    email = "josvanbakel@protonmail.com";
    github = "c0deaddict";
    githubId = 510553;
    name = "Jos van Bakel";
  };
  c4605 = {
    email = "bolasblack@gmail.com";
    github = "bolasblack";
    githubId = 382011;
    name = "c4605";
  };
  caadar = {
    email = "v88m@posteo.net";
    github = "caadar";
    githubId = 15320726;
    name = "Car Cdr";
  };
  cab404 = {
    email = "cab404@mailbox.org";
    github = "cab404";
    githubId = 6453661;
    name = "Vladimir Serov";
    keys = [
      # compare with https://keybase.io/cab404
      {
        fingerprint = "1BB96810926F4E715DEF567E6BA7C26C3FDF7BB3";
        longkeyid = "rsa3072/0xCBDECF658C38079E";
      }
      {
        fingerprint = "1EBC648C64D6045463013B3EB7EFFC271D55DB8A";
        longkeyid = "ed25519/0xB7EFFC271D55DB8A";
      }
    ];
  };
  calbrecht = {
    email = "christian.albrecht@mayflower.de";
    github = "calbrecht";
    githubId = 1516457;
    name = "Christian Albrecht";
  };
  callahad = {
    email = "dan.callahan@gmail.com";
    github = "callahad";
    githubId = 24193;
    name = "Dan Callahan";
  };
  calvertvl = {
    email = "calvertvl@gmail.com";
    github = "calvertvl";
    githubId = 7435854;
    name = "Victor Calvert";
  };
  cameronnemo = {
    email = "cnemo@tutanota.com";
    github = "cameronnemo";
    githubId = 3212452;
    name = "Cameron Nemo";
  };
  campadrenalin = {
    email = "campadrenalin@gmail.com";
    github = "campadrenalin";
    githubId = 289492;
    name = "Philip Horger";
  };
  candeira = {
    email = "javier@candeira.com";
    github = "candeira";
    githubId = 91694;
    name = "Javier Candeira";
  };
  canndrew = {
    email = "shum@canndrew.org";
    github = "canndrew";
    githubId = 5555066;
    name = "Andrew Cann";
  };
  cap = {
    name = "cap";
    email = "nixos_xasenw9@digitalpostkasten.de";
    github = "scaredmushroom";
    githubId = 45340040;
  };
  carlosdagos = {
    email = "m@cdagostino.io";
    github = "carlosdagos";
    githubId = 686190;
    name = "Carlos D'Agostino";
  };
  carlsverre = {
    email = "accounts@carlsverre.com";
    github = "carlsverre";
    githubId = 82591;
    name = "Carl Sverre";
  };
  cartr = {
    email = "carter.sande@duodecima.technology";
    github = "cartr";
    githubId = 5241813;
    name = "Carter Sande";
  };
  casey = {
    email = "casey@rodarmor.net";
    github = "casey";
    githubId = 1945;
    name = "Casey Rodarmor";
  };
  catern = {
    email = "sbaugh@catern.com";
    github = "catern";
    githubId = 5394722;
    name = "Spencer Baugh";
  };
  caugner = {
    email = "nixos@caugner.de";
    github = "caugner";
    githubId = 495429;
    name = "Claas Augner";
  };
  cawilliamson = {
    email = "home@chrisaw.com";
    github = "cawilliamson";
    githubId = 1141769;
    matrix = "@cawilliamson:nixos.dev";
    name = "Christopher A. Williamson";
  };
  cbley = {
    email = "claudio.bley@gmail.com";
    github = "avdv";
    githubId = 3471749;
    name = "Claudio Bley";
  };
  cburstedde = {
    email = "burstedde@ins.uni-bonn.de";
    github = "cburstedde";
    githubId = 109908;
    name = "Carsten Burstedde";
    keys = [{
      longkeyid = "rsa2048/0x0704CD9E550A6BCD";
      fingerprint = "1127 A432 6524 BF02 737B  544E 0704 CD9E 550A 6BCD";
    }];
  };
  cdepillabout = {
    email = "cdep.illabout@gmail.com";
    matrix = "@cdepillabout:matrix.org";
    github = "cdepillabout";
    githubId = 64804;
    name = "Dennis Gosnell";
  };
  ccellado = {
    email = "annplague@gmail.com";
    github = "ccellado";
    githubId = 44584960;
    name = "Denis Khalmatov";
  };
  ceedubs = {
    email = "ceedubs@gmail.com";
    github = "ceedubs";
    githubId = 977929;
    name = "Cody Allen";
  };
  centromere = {
    email = "nix@centromere.net";
    github = "centromere";
    githubId = 543423;
    name = "Alex Wied";
  };
  cfhammill = {
    email = "cfhammill@gmail.com";
    github = "cfhammill";
    githubId = 7467038;
    name = "Chris Hammill";
  };
  cfouche = {
    email = "chaddai.fouche@gmail.com";
    github = "Chaddai";
    githubId = 5771456;
    name = "Chaddaï Fouché";
  };
  cfsmp3 = {
    email = "carlos@sanz.dev";
    github = "cfsmp3";
    githubId = 5949913;
    name = "Carlos Fernandez Sanz";
  };
  cge = {
    email = "cevans@evanslabs.org";
    github = "cgevans";
    githubId = 2054509;
    name = "Constantine Evans";
    keys = [
      {
        longkeyid = "rsa4096/0xB67DB1D20A93A9F9";
        fingerprint = "32B1 6EE7 DBA5 16DE 526E  4C5A B67D B1D2 0A93 A9F9";
      }
      {
        longkeyid = "rsa4096/0x1A1D58B86AE2AABD";
        fingerprint = "669C 1D24 5A87 DB34 6BE4  3216 1A1D 58B8 6AE2 AABD";
      }
    ];
  };
  chaduffy = {
    email = "charles@dyfis.net";
    github = "charles-dyfis-net";
    githubId = 22370;
    name = "Charles Duffy";
  };
  changlinli = {
    email = "mail@changlinli.com";
    github = "changlinli";
    githubId = 1762540;
    name = "Changlin Li";
  };
  chanley = {
    email = "charlieshanley@gmail.com";
    github = "charlieshanley";
    githubId = 8228888;
    name = "Charlie Hanley";
  };
  CharlesHD = {
    email = "charleshdespointes@gmail.com";
    github = "CharlesHD";
    githubId = 6608071;
    name = "Charles Huyghues-Despointes";
  };
  chaoflow = {
    email = "flo@chaoflow.net";
    github = "chaoflow";
    githubId = 89596;
    name = "Florian Friesdorf";
  };
  chattered = {
    email = "me@philscotted.com";
    name = "Phil Scott";
  };
  chekoopa = {
    email = "chekoopa@mail.ru";
    github = "chekoopa";
    githubId = 1689801;
    name = "Mikhail Chekan";
  };
  ChengCat = {
    email = "yu@cheng.cat";
    github = "ChengCat";
    githubId = 33503784;
    name = "Yucheng Zhang";
  };
  cheriimoya = {
    email = "github@hausch.xyz";
    github = "cheriimoya";
    githubId = 28303440;
    name = "Max Hausch";
  };
  chessai = {
    email = "chessai1996@gmail.com";
    github = "chessai";
    githubId = 18648043;
    name = "Daniel Cartwright";
  };
  chiiruno = {
    email = "okinan@protonmail.com";
    github = "chiiruno";
    githubId = 30435868;
    name = "Okina Matara";
  };
  Chili-Man = {
    email = "dr.elhombrechile@gmail.com";
    name = "Diego Rodriguez";
    github = "Chili-Man";
    githubId = 631802;
    keys = [{
      longkeyid = "rsa4096/0xE0EBAD78F0190BD9";
      fingerprint = "099E 3F97 FA08 3D47 8C75  EBEC E0EB AD78 F019 0BD9";
    }];
  };
  chiroptical = {
    email = "chiroptical@gmail.com";
    github = "chiroptical";
    githubId = 3086255;
    name = "Barry Moore II";
  };
  chisui = {
    email = "chisui.pd@gmail.com";
    github = "chisui";
    githubId = 4526429;
    name = "Philipp Dargel";
  };
  chivay = {
    email = "hubert.jasudowicz@gmail.com";
    github = "chivay";
    githubId = 14790226;
    name = "Hubert Jasudowicz";
  };
  chkno = {
    email = "chuck@intelligence.org";
    github = "chkno";
    githubId = 1118859;
    name = "Scott Worley";
  };
  choochootrain = {
    email = "hurshal@imap.cc";
    github = "choochootrain";
    githubId = 803961;
    name = "Hurshal Patel";
  };
  chpatrick = {
    email = "chpatrick@gmail.com";
    github = "chpatrick";
    githubId = 832719;
    name = "Patrick Chilton";
  };
  chreekat = {
    email = "b@chreekat.net";
    github = "chreekat";
    githubId = 538538;
    name = "Bryan Richter";
  };
  chris-martin = {
    email = "ch.martin@gmail.com";
    github = "chris-martin";
    githubId = 399718;
    name = "Chris Martin";
  };
  chrisjefferson = {
    email = "chris@bubblescope.net";
    github = "chrisjefferson";
    githubId = 811527;
    name = "Christopher Jefferson";
  };
  chrispickard = {
    email = "chrispickard9@gmail.com";
    github = "chrispickard";
    githubId = 1438690;
    name = "Chris Pickard";
  };
  chrisrosset = {
    email = "chris@rosset.org.uk";
    github = "chrisrosset";
    githubId = 1103294;
    name = "Christopher Rosset";
  };
  christianharke = {
    email = "christian@harke.ch";
    github = "christianharke";
    githubId = 13007345;
    name = "Christian Harke";
    keys = [{
      longkeyid = "rsa4096/0x830A9728630966F4";
      fingerprint = "4EBB 30F1 E89A 541A A7F2  52BE 830A 9728 6309 66F4";
    }];
  };
  christopherpoole = {
    email = "mail@christopherpoole.net";
    github = "christopherpoole";
    githubId = 2245737;
    name = "Christopher Mark Poole";
  };
  chuahou = {
    email = "human+github@chuahou.dev";
    github = "chuahou";
    githubId = 12386805;
    name = "Chua Hou";
  };
  chuangzhu = {
    name = "Chuang Zhu";
    email = "chuang@melty.land";
    matrix = "@chuangzhu:matrix.org";
    github = "chuangzhu";
    githubId = 31200881;
    keys = [{
      longkeyid = "rsa4096/E838CED81CFFD3F9";
      fingerprint = "5D03 A5E6 0754 A3E3 CA57 5037 E838 CED8 1CFF D3F9";
    }];
  };
  chvp = {
    email = "nixpkgs@cvpetegem.be";
    matrix = "@charlotte:vanpetegem.me";
    github = "chvp";
    githubId = 42220376;
    name = "Charlotte Van Petegem";
  };
  ciil = {
    email = "simon@lackerbauer.com";
    github = "ciil";
    githubId = 3956062;
    name = "Simon Lackerbauer";
  };
  cirno-999 = {
    email = "reverene@protonmail.com";
    github = "cirno-999";
    githubId = 73712874;
    name = "cirno-999";
  };
  citadelcore = {
    email = "alex@arctarus.co.uk";
    github = "citadelcore";
    githubId = 5567402;
    name = "Alex Zero";
    keys = [{
      longkeyid = "rsa4096/0xA51550EDB450302C";
      fingerprint = "A0AA 4646 B8F6 9D45 4553  5A88 A515 50ED B450 302C";
    }];
  };
  cizra = {
    email = "todurov+nix@gmail.com";
    github = "cizra";
    githubId = 2131991;
    name = "Elmo Todurov";
  };
  cjab = {
    email = "chad+nixpkgs@jablonski.xyz";
    github = "cjab";
    githubId = 136485;
    name = "Chad Jablonski";
  };
  ck3d = {
    email = "ck3d@gmx.de";
    github = "ck3d";
    githubId = 25088352;
    name = "Christian Kögler";
  };
  ckie = {
    email = "nixpkgs-0efe364@ckie.dev";
    github = "ckiee";
    githubId = 2526321;
    keys = [{
      longkeyid = "rsa4096/0x13E79449C0525215";
      fingerprint = "539F 0655 4D35 38A5 429A  E253 13E7 9449 C052 5215";
    }];
    name = "ckie";
  };
  clkamp = {
    email = "c@lkamp.de";
    github = "clkamp";
    githubId = 46303707;
    name = "Christian Lütke-Stetzkamp";
  };
  ckauhaus = {
    email = "kc@flyingcircus.io";
    github = "ckauhaus";
    githubId = 1448923;
    name = "Christian Kauhaus";
  };
  cko = {
    email = "christine.koppelt@gmail.com";
    github = "cko";
    githubId = 68239;
    name = "Christine Koppelt";
  };
  clacke = {
    email = "claes.wallin@greatsinodevelopment.com";
    github = "clacke";
    githubId = 199180;
    name = "Claes Wallin";
  };
  cleeyv = {
    email = "cleeyv@riseup.net";
    github = "cleeyv";
    githubId = 71959829;
    name = "Cleeyv";
  };
  cleverca22 = {
    email = "cleverca22@gmail.com";
    matrix = "@cleverca22:matrix.org";
    github = "cleverca22";
    githubId = 848609;
    name = "Michael Bishop";
  };
  cmacrae = {
    email = "hi@cmacr.ae";
    github = "cmacrae";
    githubId = 3392199;
    name = "Calum MacRae";
  };
  cmars = {
    email = "nix@cmars.tech";
    github = "cmars";
    githubId = 23741;
    name = "Casey Marshall";
    keys = [{
      longkeyid = "rsa3072/0x6DEC2758ACD5A973";
      fingerprint = "6B78 7E5F B493 FA4F D009  5D10 6DEC 2758 ACD5 A973";
    }];
  };
  cmcdragonkai = {
    email = "roger.qiu@matrix.ai";
    github = "cmcdragonkai";
    githubId = 640797;
    name = "Roger Qiu";
  };
  cmfwyp = {
    email = "cmfwyp@riseup.net";
    github = "cmfwyp";
    githubId = 20808761;
    name = "cmfwyp";
  };
  cobbal = {
    email = "andrew.cobb@gmail.com";
    github = "cobbal";
    githubId = 180339;
    name = "Andrew Cobb";
  };
  coconnor = {
    email = "coreyoconnor@gmail.com";
    github = "coreyoconnor";
    githubId = 34317;
    name = "Corey O'Connor";
  };
  CodeLongAndProsper90 = {
    github = "CodeLongAndProsper90";
    githubId = 50145141;
    email = "jupiter@m.rdis.dev";
    name = "Scott Little";
  };
  codsl = {
    email = "codsl@riseup.net";
    github = "codsl";
    githubId = 6402559;
    name = "codsl";
  };
  codyopel = {
    email = "codyopel@gmail.com";
    github = "codyopel";
    githubId = 5561189;
    name = "Cody Opel";
  };
  Cogitri = {
    email = "oss@cogitri.dev";
    github = "Cogitri";
    githubId = 8766773;
    matrix = "@cogitri:cogitri.dev";
    name = "Rasmus Thomsen";
  };
  cohei = {
    email = "a.d.xvii.kal.mai@gmail.com";
    github = "cohei";
    githubId = 3477497;
    name = "TANIGUCHI Kohei";
  };
  cohencyril = {
    email = "cyril.cohen@inria.fr";
    github = "CohenCyril";
    githubId = 298705;
    name = "Cyril Cohen";
  };
  colemickens = {
    email = "cole.mickens@gmail.com";
    matrix = "@colemickens:matrix.org";
    github = "colemickens";
    githubId = 327028;
    name = "Cole Mickens";
  };
  colescott = {
    email = "colescottsf@gmail.com";
    github = "colescott";
    githubId = 5684605;
    name = "Cole Scott";
  };
  cole-h = {
    name = "Cole Helbling";
    email = "cole.e.helbling@outlook.com";
    matrix = "@cole-h:matrix.org";
    github = "cole-h";
    githubId = 28582702;
    keys = [{
      longkeyid = "rsa4096/0xB37E0F2371016A4C";
      fingerprint = "68B8 0D57 B2E5 4AC3 EC1F  49B0 B37E 0F23 7101 6A4C";
    }];
  };
  collares = {
    email = "mauricio@collares.org";
    github = "collares";
    githubId = 244239;
    name = "Mauricio Collares";
  };
  copumpkin = {
    email = "pumpkingod@gmail.com";
    github = "copumpkin";
    githubId = 2623;
    name = "Dan Peebles";
  };
  corngood = {
    email = "corngood@gmail.com";
    github = "corngood";
    githubId = 3077118;
    name = "David McFarland";
  };
  coroa = {
    email = "jonas@chaoflow.net";
    github = "coroa";
    githubId = 2552981;
    name = "Jonas Hörsch";
  };
  costrouc = {
    email = "chris.ostrouchov@gmail.com";
    github = "costrouc";
    githubId = 1740337;
    name = "Chris Ostrouchov";
  };
  confus = {
    email = "con-f-use@gmx.net";
    github = "con-f-use";
    githubId = 11145016;
    name = "J.C.";
  };
  contrun = {
    email = "uuuuuu@protonmail.com";
    github = "contrun";
    githubId = 32609395;
    name = "B YI";
  };
  conradmearns = {
    email = "conradmearns+github@pm.me";
    github = "ConradMearns";
    githubId = 5510514;
    name = "Conrad Mearns";
  };
  couchemar = {
    email = "couchemar@yandex.ru";
    github = "couchemar";
    githubId = 1573344;
    name = "Andrey Pavlov";
  };
  cpages = {
    email = "page@ruiec.cat";
    github = "cpages";
    githubId = 411324;
    name = "Carles Pagès";
  };
  cpu = {
    email = "daniel@binaryparadox.net";
    github = "cpu";
    githubId = 292650;
    name = "Daniel McCarney";
    keys = [{
      longkeyid = "rsa2048/0x08FB2BFC470E75B4";
      fingerprint = "8026 D24A A966 BF9C D3CD  CB3C 08FB 2BFC 470E 75B4";
    }];
  };
  craigem = {
    email = "craige@mcwhirter.io";
    github = "craigem";
    githubId = 6470493;
    name = "Craige McWhirter";
  };
  cransom = {
    email = "cransom@hubns.net";
    github = "cransom";
    githubId = 1957293;
    name = "Casey Ransom";
  };
  CrazedProgrammer = {
    email = "crazedprogrammer@gmail.com";
    github = "CrazedProgrammer";
    githubId = 12202789;
    name = "CrazedProgrammer";
  };
  creator54 = {
    email = "hi.creator54@gmail.com";
    github = "creator54";
    githubId = 34543609;
    name = "creator54";
  };
  cript0nauta = {
    email = "shareman1204@gmail.com";
    github = "cript0nauta";
    githubId = 1222362;
    name = "Matías Lang";
  };
  CRTified = {
    email = "carl.schneider+nixos@rub.de";
    matrix = "@schnecfk:ruhr-uni-bochum.de";
    github = "CRTified";
    githubId = 2440581;
    name = "Carl Richard Theodor Schneider";
    keys = [{
      longkeyid = "rsa4096/0x45BCC1E2709B1788";
      fingerprint = "2017 E152 BB81 5C16 955C  E612 45BC C1E2 709B 1788";
    }];
  };
  cryptix = {
    email = "cryptix@riseup.net";
    github = "cryptix";
    githubId = 111202;
    name = "Henry Bubert";
  };
  CrystalGamma = {
    email = "nixos@crystalgamma.de";
    github = "CrystalGamma";
    githubId = 6297001;
    name = "Jona Stubbe";
  };
  csingley = {
    email = "csingley@gmail.com";
    github = "csingley";
    githubId = 398996;
    name = "Christopher Singley";
  };
  cstrahan = {
    email = "charles@cstrahan.com";
    github = "cstrahan";
    githubId = 143982;
    name = "Charles Strahan";
  };
  cswank = {
    email = "craigswank@gmail.com";
    github = "cswank";
    githubId = 490965;
    name = "Craig Swank";
  };
  cust0dian = {
    email = "serg@effectful.software";
    github = "cust0dian";
    githubId = 389387;
    name = "Serg Nesterov";
    keys = [{
      longkeyid = "rsa4096/0x1512F6EB84AECC8C";
      fingerprint = "6E7D BA30 DB5D BA60 693C  3BE3 1512 F6EB 84AE CC8C";
    }];
  };
  cwoac = {
    email = "oliver@codersoffortune.net";
    github = "cwoac";
    githubId = 1382175;
    name = "Oliver Matthews";
  };
  cyounkins = {
    name = "Craig Younkins";
    email = "cyounkins@gmail.com";
    github = "cyounkins";
    githubId = 346185;
  };
  cypherpunk2140 = {
    email = "stefan.mihaila@pm.me";
    github = "stefan-mihaila";
    githubId = 2217136;
    name = "Ștefan D. Mihăilă";
    keys = [
      {
        longkeyid = "rsa4096/6E68A39BF16A3ECB";
        fingerprint = "CBC9 C7CC 51F0 4A61 3901 C723 6E68 A39B F16A 3ECB";
      }
      {
        longkeyid = "rsa4096/6220AD7846220A52";
        fingerprint = "7EAB 1447 5BBA 7DDE 7092 7276 6220 AD78 4622 0A52";
      }
    ];
  };
  cyplo = {
    email = "nixos@cyplo.dev";
    matrix = "@cyplo:cyplo.dev";
    github = "cyplo";
    githubId = 217899;
    name = "Cyryl Płotnicki";
  };
  d-goldin = {
    email = "dgoldin+github@protonmail.ch";
    github = "d-goldin";
    githubId = 43349662;
    name = "Dima";
    keys = [{
      longkeyid = "rsa4096/BAB1D15FB7B4D4CE";
      fingerprint = "1C4E F4FE 7F8E D8B7 1E88 CCDF BAB1 D15F B7B4 D4CE";
    }];
  };
  d-xo = {
    email = "hi@d-xo.org";
    github = "d-xo";
    githubId = 6689924;
    name = "David Terry";
  };
  dadada = {
    name = "dadada";
    email = "dadada@dadada.li";
    github = "dadada";
    githubId = 7216772;
    keys = [{
      longkeyid = "ed25519/0xEEB8D1CE62C4DFEA";
      fingerprint = "D68C 8469 5C08 7E0F 733A  28D0 EEB8 D1CE 62C4 DFEA";
    }];
  };
  dalance = {
    email = "dalance@gmail.com";
    github = "dalance";
    githubId = 4331004;
    name = "Naoya Hatta";
  };
  dalpd = {
    email = "denizalpd@ogr.iu.edu.tr";
    github = "dalpd";
    githubId = 16895361;
    name = "Deniz Alp Durmaz";
  };
  DamienCassou = {
    email = "damien@cassou.me";
    github = "DamienCassou";
    githubId = 217543;
    name = "Damien Cassou";
  };
  danbst = {
    email = "abcz2.uprola@gmail.com";
    github = "danbst";
    githubId = 743057;
    name = "Danylo Hlynskyi";
  };
  dancek = {
    email = "hannu.hartikainen@gmail.com";
    github = "dancek";
    githubId = 245394;
    name = "Hannu Hartikainen";
  };
  danderson = {
    email = "dave@natulte.net";
    github = "danderson";
    githubId = 1918;
    name = "David Anderson";
  };
  dandellion = {
    email = "daniel@dodsorf.as";
    matrix = "@dandellion:dodsorf.as";
    github = "dali99";
    githubId = 990767;
    name = "Daniel Olsen";
  };
  daneads = {
    email = "me@daneads.com";
    github = "daneads";
    githubId = 24708079;
    name = "Dan Eads";
  };
  danharaj = {
    email = "dan@obsidian.systems";
    github = "danharaj";
    githubId = 23366017;
    name = "Dan Haraj";
  };
  danielbarter = {
    email = "danielbarter@gmail.com";
    github = "danielbarter";
    githubId = 8081722;
    name = "Daniel Barter";
  };
  danieldk = {
    email = "me@danieldk.eu";
    github = "danieldk";
    githubId = 49398;
    name = "Daniël de Kok";
  };
  danielfullmer = {
    email = "danielrf12@gmail.com";
    github = "danielfullmer";
    githubId = 1298344;
    name = "Daniel Fullmer";
  };
  danth = {
    name = "Daniel Thwaites";
    email = "danthwaites30@btinternet.com";
    matrix = "@danth:matrix.org";
    github = "danth";
    githubId = 28959268;
    keys = [{
      longkeyid = "rsa3072/0xD8AFC4BF05670F9D";
      fingerprint = "4779 D1D5 3C97 2EAE 34A5  ED3D D8AF C4BF 0567 0F9D";
    }];
  };
  dan4ik605743 = {
    email = "6057430gu@gmail.com";
    github = "dan4ik605743";
    githubId = 86075850;
    name = "Danil Danevich";
  };
  darkonion0 = {
    name = "Alexandre Peruggia";
    email = "darkgenius1@protonmail.com";
    matrix = "@alexoo:matrix.org";
    github = "DarkOnion0";
    githubId = 68606322;
  };
  das-g = {
    email = "nixpkgs@raphael.dasgupta.ch";
    github = "das-g";
    githubId = 97746;
    name = "Raphael Das Gupta";
  };
  das_j = {
    email = "janne@hess.ooo";
    matrix = "@janne.hess:helsinki-systems.de";
    github = "dasJ";
    githubId = 4971975;
    name = "Janne Heß";
  };
  dasisdormax = {
    email = "dasisdormax@mailbox.org";
    github = "dasisdormax";
    githubId = 3714905;
    keys = [{
      longkeyid = "rsa4096/0x02BA0D4480CA6C44";
      fingerprint = "E59B A198 61B0 A9ED C1FA  3FB2 02BA 0D44 80CA 6C44";
    }];
    name = "Maximilian Wende";
  };
  dasj19 = {
    email = "daniel@serbanescu.dk";
    github = "dasj19";
    githubId = 7589338;
    name = "Daniel Șerbănescu";
  };
  dasuxullebt = {
    email = "christoph.senjak@googlemail.com";
    name = "Christoph-Simon Senjak";
  };
  datafoo = {
    email = "34766150+datafoo@users.noreply.github.com";
    github = "datafoo";
    githubId = 34766150;
    name = "datafoo";
  };
  davhau = {
    email = "d.hauer.it@gmail.com";
    name = "David Hauer";
    github = "DavHau";
    githubId = 42246742;
  };
  david-sawatzke = {
    email = "d-nix@sawatzke.dev";
    github = "david-sawatzke";
    githubId = 11035569;
    name = "David Sawatzke";
  };
  david50407 = {
    email = "me@davy.tw";
    github = "david50407";
    githubId = 841969;
    name = "David Kuo";
  };
  davidak = {
    email = "post@davidak.de";
    matrix = "@davidak:matrix.org";
    github = "davidak";
    githubId = 91113;
    name = "David Kleuker";
  };
  davidarmstronglewis = {
    email = "davidlewis@mac.com";
    github = "davidarmstronglewis";
    githubId = 6754950;
    name = "David Armstrong Lewis";
  };
  davidrusu = {
    email = "davidrusu.me@gmail.com";
    github = "davidrusu";
    githubId = 1832378;
    name = "David Rusu";
  };
  davidtwco = {
    email = "nix@david.davidtw.co";
    github = "davidtwco";
    githubId = 1295100;
    name = "David Wood";
    keys = [{
      longkeyid = "rsa4096/0x01760B4F9F53F154";
      fingerprint = "5B08 313C 6853 E5BF FA91  A817 0176 0B4F 9F53 F154";
    }];
  };
  davorb = {
    email = "davor@davor.se";
    github = "davorb";
    githubId = 798427;
    name = "Davor Babic";
  };
  dawidsowa = {
    email = "dawid_sowa@posteo.net";
    github = "dawidsowa";
    githubId = 49904992;
    name = "Dawid Sowa";
  };
  dbirks = {
    email = "david@birks.dev";
    github = "dbirks";
    githubId = 7545665;
    name = "David Birks";
    keys = [{
      longkeyid = "ed25519/0xBB999F83D9A19A36";
      fingerprint = "B26F 9AD8 DA20 3392 EF87  C61A BB99 9F83 D9A1 9A36";
    }];
  };
  dbohdan = {
    email = "dbohdan@dbohdan.com";
    github = "dbohdan";
    githubId = 3179832;
    name = "D. Bohdan";
  };
  dbrock = {
    email = "daniel@brockman.se";
    github = "dbrock";
    githubId = 14032;
    name = "Daniel Brockman";
  };
  ddelabru = {
    email = "ddelabru@redhat.com";
    github = "ddelabru";
    githubId = 39909293;
    name = "Dominic Delabruere";
  };
  dduan = {
    email = "daniel@duan.ca";
    github = "dduan";
    githubId = 75067;
    name = "Daniel Duan";
  };
  dearrude = {
    name = "Ebrahim Nejati";
    email = "dearrude@tfwno.gf";
    github = "dearrude";
    githubId = 30749142;
    keys = [{
      longkeyid = "rsa4096/19151E03BF2CF012";
      fingerprint = "4E35 F2E5 2132 D654 E815  A672 DB2C BC24 2868 6000";
    }];
  };
  deepfire = {
    email = "_deepfire@feelingofgreen.ru";
    github = "deepfire";
    githubId = 452652;
    name = "Kosyrev Serge";
  };
  DeeUnderscore = {
    email = "d.anzorge@gmail.com";
    github = "DeeUnderscore";
    githubId = 156239;
    name = "D Anzorge";
  };
  delan = {
    name = "Delan Azabani";
    email = "delan@azabani.com";
    github = "delan";
    githubId = 465303;
  };
  deliciouslytyped = {
    email = "47436522+deliciouslytyped@users.noreply.github.com";
    github = "deliciouslytyped";
    githubId = 47436522;
    name = "deliciouslytyped";
  };
  delroth = {
    email = "delroth@gmail.com";
    github = "delroth";
    githubId = 202798;
    name = "Pierre Bourdon";
  };
  delta = {
    email = "d4delta@outlook.fr";
    name = "Delta";
  };
  deltadelta = {
    email = "contact@libellules.eu";
    name = "Dara Ly";
    github = "tournemire";
    githubId = 20159432;
  };
  deltaevo = {
    email = "deltaduartedavid@gmail.com";
    github = "DeltaEvo";
    githubId = 8864716;
    name = "Duarte David";
  };
  demin-dmitriy = {
    email = "demindf@gmail.com";
    github = "demin-dmitriy";
    githubId = 5503422;
    name = "Dmitriy Demin";
  };
  demize = {
    email = "johannes@kyriasis.com";
    github = "kyrias";
    githubId = 2285387;
    name = "Johannes Löthberg";
  };
  demyanrogozhin = {
    email = "demyan.rogozhin@gmail.com";
    github = "demyanrogozhin";
    githubId = 62989;
    name = "Demyan Rogozhin";
  };
  derchris = {
    email = "derchris@me.com";
    github = "derchrisuk";
    githubId = 706758;
    name = "Christian Gerbrandt";
  };
  derekcollison = {
    email = "derek@nats.io";
    github = "derekcollison";
    githubId = 90097;
    name = "Derek Collison";
  };
  DerGuteMoritz = {
    email = "moritz@twoticketsplease.de";
    github = "DerGuteMoritz";
    githubId = 19733;
    name = "Moritz Heidkamp";
  };
  dermetfan = {
    email = "serverkorken@gmail.com";
    github = "dermetfan";
    githubId = 4956158;
    name = "Robin Stumm";
  };
  DerTim1 = {
    email = "tim.digel@active-group.de";
    github = "DerTim1";
    githubId = 21953890;
    name = "Tim Digel";
  };
  desiderius = {
    email = "didier@devroye.name";
    github = "desiderius";
    githubId = 1311761;
    name = "Didier J. Devroye";
  };
  devhell = {
    email = ''"^"@regexmail.net'';
    github = "devhell";
    githubId = 896182;
    name = "devhell";
  };
  devins2518 = {
    email = "drsingh2518@icloud.com";
    github = "devins2518";
    githubId = 17111639;
    name = "Devin Singh";
  };
  dezgeg = {
    email = "tuomas.tynkkynen@iki.fi";
    github = "dezgeg";
    githubId = 579369;
    name = "Tuomas Tynkkynen";
  };
  dfordivam = {
    email = "dfordivam+nixpkgs@gmail.com";
    github = "dfordivam";
    githubId = 681060;
    name = "Divam";
  };
  dfoxfranke = {
    email = "dfoxfranke@gmail.com";
    github = "dfoxfranke";
    githubId = 4708206;
    name = "Daniel Fox Franke";
  };
  dgliwka = {
    email = "dawid.gliwka@gmail.com";
    github = "dgliwka";
    githubId = 33262214;
    name = "Dawid Gliwka";
  };
  dgonyeo = {
    email = "derek@gonyeo.com";
    github = "dgonyeo";
    githubId = 2439413;
    name = "Derek Gonyeo";
  };
  dguenther = {
    email = "dguenther9@gmail.com";
    github = "dguenther";
    githubId = 767083;
    name = "Derek Guenther";
  };
  dhkl = {
    email = "david@davidslab.com";
    github = "dhl";
    githubId = 265220;
    name = "David Leung";
  };
  DianaOlympos = {
    email = "DianaOlympos@noreply.github.com";
    github = "DianaOlympos";
    githubId = 15774340;
    name = "Thomas Depierre";
  };
  diegolelis = {
    email = "diego.o.lelis@gmail.com";
    github = "diegolelis";
    githubId = 8404455;
    name = "Diego Lelis";
  };
  diffumist = {
    email = "git@diffumist.me";
    github = "diffumist";
    githubId = 32810399;
    name = "Diffumist";
  };
  diogox = {
    name = "Diogo Xavier";
    email = "13244408+diogox@users.noreply.github.com";
    github = "diogox";
    githubId = 13244408;
  };
  dipinhora = {
    email = "dipinhora+github@gmail.com";
    github = "dipinhora";
    githubId = 11946442;
    name = "Dipin Hora";
  };
  dirkx = {
    email = "dirkx@webweaving.org";
    github = "dirkx";
    githubId = 392583;
    name = "Dirk-Willem van Gulik";
  };
  disassembler = {
    email = "disasm@gmail.com";
    github = "disassembler";
    githubId = 651205;
    name = "Samuel Leathers";
  };
  disserman = {
    email = "disserman@gmail.com";
    github = "divi255";
    githubId = 40633781;
    name = "Sergei S.";
  };
  dit7ya = {
    email = "7rat13@gmail.com";
    github = "dit7ya";
    githubId = 14034137;
    name = "Mostly Void";
  };
  dizfer = {
    email = "david@izquierdofernandez.com";
    github = "dizfer";
    githubId = 8852888;
    name = "David Izquierdo";
  };
  djanatyn = {
    email = "djanatyn@gmail.com";
    github = "djanatyn";
    githubId = 523628;
    name = "Jonathan Strickland";
  };
  Dje4321 = {
    email = "dje4321@gmail.com";
    github = "dje4321";
    githubId = 10913120;
    name = "Dje4321";
  };
  djwf = {
    email = "dave@weller-fahy.com";
    github = "djwf";
    githubId = 73162;
    name = "David J. Weller-Fahy";
  };
  dkabot = {
    email = "dkabot@dkabot.com";
    github = "dkabot";
    githubId = 1316469;
    name = "Naomi Morse";
  };
  dlesl = {
    email = "dlesl@dlesl.com";
    github = "dlesl";
    githubId = 28980797;
    name = "David Leslie";
  };
  dlip = {
    email = "dane@lipscombe.com.au";
    github = "dlip";
    githubId = 283316;
    name = "Dane Lipscombe";
  };
  dmalikov = {
    email = "malikov.d.y@gmail.com";
    github = "dmalikov";
    githubId = 997543;
    name = "Dmitry Malikov";
  };
  DmitryTsygankov = {
    email = "dmitry.tsygankov@gmail.com";
    github = "DmitryTsygankov";
    githubId = 425354;
    name = "Dmitry Tsygankov";
  };
  dmjio = {
    email = "djohnson.m@gmail.com";
    github = "dmjio";
    githubId = 875324;
    name = "David Johnson";
  };
  dmrauh = {
    email = "dmrauh@posteo.de";
    github = "dmrauh";
    githubId = 37698547;
    name = "Dominik Michael Rauh";
  };
  dmvianna = {
    email = "dmlvianna@gmail.com";
    github = "dmvianna";
    githubId = 1708810;
    name = "Daniel Vianna";
  };
  dnr = {
    email = "dnr@dnr.im";
    github = "dnr";
    githubId = 466723;
    name = "David Reiss";
  };
  dochang = {
    email = "dochang@gmail.com";
    github = "dochang";
    githubId = 129093;
    name = "Desmond O. Chang";
  };
  domenkozar = {
    email = "domen@dev.si";
    github = "domenkozar";
    githubId = 126339;
    name = "Domen Kozar";
  };
  dominikh = {
    email = "dominik@honnef.co";
    github = "dominikh";
    githubId = 39825;
    name = "Dominik Honnef";
  };
  doronbehar = {
    email = "me@doronbehar.com";
    github = "doronbehar";
    githubId = 10998835;
    name = "Doron Behar";
  };
  dotlambda = {
    email = "rschuetz17@gmail.com";
    matrix = "@robert:funklause.de";
    github = "dotlambda";
    githubId = 6806011;
    name = "Robert Schütz";
  };
  dottedmag = {
    email = "dottedmag@dottedmag.net";
    github = "dottedmag";
    githubId = 16120;
    name = "Misha Gusarov";
    keys = [{
      longkeyid = "rsa4096/0x9D20F6503E338888";
      fingerprint = "A8DF 1326 9E5D 9A38 E57C  FAC2 9D20 F650 3E33 8888";
    }];
  };
  doublec = {
    email = "chris.double@double.co.nz";
    github = "doublec";
    githubId = 16599;
    name = "Chris Double";
  };
  dpaetzel = {
    email = "david.paetzel@posteo.de";
    github = "dpaetzel";
    githubId = 974130;
    name = "David Pätzel";
  };
  dpausp = {
    email = "dpausp@posteo.de";
    github = "dpausp";
    githubId = 1965950;
    name = "Tobias Stenzel";
    keys = [{
      longkeyid = "rsa2048/0x78C7DD40DF23FB16";
      fingerprint = "4749 0887 CF3B 85A1 6355  C671 78C7 DD40 DF23 FB16";
    }];
  };
  dpercy = {
    email = "dpercy@dpercy.dev";
    github = "dpercy";
    githubId = 349909;
    name = "David Percy";
  };
  dpflug = {
    email = "david@pflug.email";
    github = "dpflug";
    githubId = 108501;
    name = "David Pflug";
  };
  dramaturg = {
    email = "seb@ds.ag";
    github = "dramaturg";
    githubId = 472846;
    name = "Sebastian Krohn";
  };
  drets = {
    email = "dmitryrets@gmail.com";
    github = "drets";
    githubId = 6199462;
    name = "Dmytro Rets";
  };
  drewkett = {
    email = "burkett.andrew@gmail.com";
    name = "Andrew Burkett";
  };
  drewrisinger = {
    email = "drisinger+nixpkgs@gmail.com";
    github = "drewrisinger";
    githubId = 10198051;
    name = "Drew Risinger";
  };
  drperceptron = {
    email = "92106371+drperceptron@users.noreply.github.com";
    github = "drperceptron";
    githubId = 92106371;
    name = "Dr Perceptron";
    keys = [{
      longkeyid = "rsa4096/0x95EB6DFF26D1CEB0";
      fingerprint = "7E38 89D9 B1A8 B381 C8DE  A15F 95EB 6DFF 26D1 CEB0";
    }];
  };
  drupol = {
    name = "Pol Dellaiera";
    email = "pol.dellaiera@protonmail.com";
    matrix = "@drupol:matrix.org";
    github = "drupol";
    githubId = 252042;
    keys = [{
      longkeyid = "ed25519/0x0AAF2901E8040715";
      fingerprint = "85F3 72DF 4AF3 EF13 ED34  72A3 0AAF 2901 E804 0715";
    }];
  };
  drzoidberg = {
    email = "jakob@mast3rsoft.com";
    github = "jakobneufeld";
    githubId = 24791219;
    name = "Jakob Neufeld";
  };
  dsalaza4 = {
    email = "podany270895@gmail.com";
    github = "dsalaza4";
    githubId = 11205987;
    name = "Daniel Salazar";
  };
  dschrempf = {
    name = "Dominik Schrempf";
    email = "dominik.schrempf@gmail.com";
    github = "dschrempf";
    githubId = 5596239;
    keys = [{
      longkeyid = "rsa2048/0x875F2BCF163F1B29";
      fingerprint = "62BC E2BD 49DF ECC7 35C7  E153 875F 2BCF 163F 1B29";
    }];
  };
  dsferruzza = {
    email = "david.sferruzza@gmail.com";
    github = "dsferruzza";
    githubId = 1931963;
    name = "David Sferruzza";
  };
  dtzWill = {
    email = "w@wdtz.org";
    github = "dtzWill";
    githubId = 817330;
    name = "Will Dietz";
    keys = [{
      longkeyid = "rsa4096/0xFD42C7D0D41494C8";
      fingerprint = "389A 78CB CD88 5E0C 4701  DEB9 FD42 C7D0 D414 94C8";
    }];
  };
  dump_stack = {
    email = "root@dumpstack.io";
    github = "jollheef";
    githubId = 1749762;
    name = "Mikhail Klementev";
    keys = [{
      longkeyid = "rsa4096/0x1525585D1B43C62A";
      fingerprint = "5DD7 C6F6 0630 F08E DAE7  4711 1525 585D 1B43 C62A";
    }];
  };
  dwarfmaster = {
    email = "nixpkgs@dwarfmaster.net";
    github = "dwarfmaster";
    githubId = 2025623;
    name = "Luc Chabassier";
  };
  dxf = {
    email = "dingxiangfei2009@gmail.com";
    github = "dingxiangfei2009";
    githubId = 6884440;
    name = "Ding Xiang Fei";
  };
  dysinger = {
    email = "tim@dysinger.net";
    github = "dysinger";
    githubId = 447;
    name = "Tim Dysinger";
  };
  dywedir = {
    email = "dywedir@gra.red";
    matrix = "@dywedir:matrix.org";
    github = "dywedir";
    githubId = 399312;
    name = "Vladyslav M.";
  };
  dzabraev = {
    email = "dzabraew@gmail.com";
    github = "dzabraev";
    githubId = 15128988;
    name = "Maksim Dzabraev";
  };
  e-user = {
    email = "nixos@sodosopa.io";
    github = "e-user";
    githubId = 93086;
    name = "Alexander Kahl";
  };
  eadwu = {
    email = "edmund.wu@protonmail.com";
    github = "eadwu";
    githubId = 22758444;
    name = "Edmund Wu";
  };
  ealasu = {
    email = "emanuel.alasu@gmail.com";
    github = "ealasu";
    githubId = 1362096;
    name = "Emanuel Alasu";
  };
  eamsden = {
    email = "edward@blackriversoft.com";
    github = "eamsden";
    githubId = 54573;
    name = "Edward Amsden";
  };
  earldouglas = {
    email = "james@earldouglas.com";
    github = "earldouglas";
    githubId = 424946;
    name = "James Earl Douglas";
  };
  earvstedt = {
    email = "erik.arvstedt@gmail.com";
    matrix = "@erikarvstedt:matrix.org";
    github = "erikarvstedt";
    githubId = 36110478;
    name = "Erik Arvstedt";
  };
  ebbertd = {
    email = "daniel@ebbert.nrw";
    github = "ebbertd";
    githubId = 20522234;
    name = "Daniel Ebbert";
    keys = [{
      longkeyid = "rsa2048/0x47BC155927CBB9C7";
      fingerprint = "E765 FCA3 D9BF 7FDB 856E  AD73 47BC 1559 27CB B9C7";
    }];
  };
  ebzzry = {
    email = "ebzzry@ebzzry.io";
    github = "ebzzry";
    githubId = 7875;
    name = "Rommel Martinez";
  };
  edanaher = {
    email = "nixos@edanaher.net";
    github = "edanaher";
    githubId = 984691;
    name = "Evan Danaher";
  };
  edbentley = {
    email = "hello@edbentley.dev";
    github = "edbentley";
    githubId = 15923595;
    name = "Ed Bentley";
  };
  edcragg = {
    email = "ed.cragg@eipi.xyz";
    github = "nuxeh";
    githubId = 1516017;
    name = "Ed Cragg";
  };
  edef = {
    email = "edef@edef.eu";
    github = "edef1c";
    githubId = 50854;
    name = "edef";
  };
  edlimerkaj = {
    name = "Edli Merkaj";
    email = "edli.merkaj@identinet.io";
    github = "edlimerkaj";
    githubId = 71988351;
  };
  emantor = {
    email = "rouven+nixos@czerwinskis.de";
    github = "emantor";
    githubId = 934284;
    name = "Rouven Czerwinski";
  };
  embr = {
    email = "hi@liclac.eu";
    github = "liclac";
    githubId = 428026;
    name = "embr";
  };
  emily = {
    email = "nixpkgs@emily.moe";
    github = "emilazy";
    githubId = 18535642;
    name = "Emily";
  };
  enderger = {
    email = "endergeryt@gmail.com";
    github = "enderger";
    githubId = 36283171;
    name = "Daniel";
  };
  endocrimes = {
    email = "dani@builds.terrible.systems";
    github = "endocrimes";
    githubId = 1330683;
    name = "Danielle Lancashire";
  };
  ederoyd46 = {
    email = "matt@ederoyd.co.uk";
    github = "ederoyd46";
    githubId = 119483;
    name = "Matthew Brown";
  };
  eduarrrd = {
    email = "e.bachmakov@gmail.com";
    github = "eduarrrd";
    githubId = 1181393;
    name = "Eduard Bachmakov";
  };
  edude03 = {
    email = "michael@melenion.com";
    github = "edude03";
    githubId = 494483;
    name = "Michael Francis";
  };
  edwtjo = {
    email = "ed@cflags.cc";
    github = "edwtjo";
    githubId = 54799;
    name = "Edward Tjörnhammar";
  };
  eelco = {
    email = "edolstra+nixpkgs@gmail.com";
    github = "edolstra";
    githubId = 1148549;
    name = "Eelco Dolstra";
  };
  ehegnes = {
    email = "eric.hegnes@gmail.com";
    github = "ehegnes";
    githubId = 884970;
    name = "Eric Hegnes";
  };
  ehmry = {
    email = "ehmry@posteo.net";
    github = "ehmry";
    githubId = 537775;
    name = "Emery Hemingway";
  };
  eikek = {
    email = "eike.kettner@posteo.de";
    github = "eikek";
    githubId = 701128;
    name = "Eike Kettner";
  };
  ekleog = {
    email = "leo@gaspard.io";
    matrix = "@leo:gaspard.ninja";
    github = "ekleog";
    githubId = 411447;
    name = "Leo Gaspard";
  };
  elasticdog = {
    email = "aaron@elasticdog.com";
    github = "elasticdog";
    githubId = 4742;
    name = "Aaron Bull Schaefer";
  };
  elatov = {
    email = "elatov@gmail.com";
    github = "elatov";
    githubId = 7494394;
    name = "Karim Elatov";
  };
  eleanor = {
    email = "dejan@proteansec.com";
    github = "proteansec";
    githubId = 1753498;
    name = "Dejan Lukan";
  };
  electrified = {
    email = "ed@maidavale.org";
    github = "electrified";
    githubId = 103082;
    name = "Ed Brindley";
  };
  elliot = {
    email = "hack00mind@gmail.com";
    github = "Eliot00";
    githubId = 18375468;
    name = "Elliot Xu";
  };
  elliottvillars = {
    email = "elliottvillars@gmail.com";
    github = "elliottvillars";
    githubId = 48104179;
    name = "Elliott Villars";
  };
  eliasp = {
    email = "mail@eliasprobst.eu";
    matrix = "@eliasp:kde.org";
    github = "eliasp";
    githubId = 48491;
    name = "Elias Probst";
  };
  elijahcaine = {
    email = "elijahcainemv@gmail.com";
    github = "pop";
    githubId = 1897147;
    name = "Elijah Caine";
  };
  elitak = {
    email = "elitak@gmail.com";
    github = "elitak";
    githubId = 769073;
    name = "Eric Litak";
  };
  ellis = {
    email = "nixos@ellisw.net";
    github = "ellis";
    githubId = 97852;
    name = "Ellis Whitehead";
  };
  elkowar = {
    email = "thereal.elkowar@gmail.com";
    github = "elkowar";
    githubId = 5300871;
    name = "Leon Kowarschick";
  };
  elohmeier = {
    email = "elo-nixos@nerdworks.de";
    github = "elohmeier";
    githubId = 2536303;
    name = "Enno Lohmeier";
  };
  elseym = {
    email = "elseym@me.com";
    github = "elseym";
    githubId = 907478;
    name = "Simon Waibl";
  };
  elvishjerricco = {
    email = "elvishjerricco@gmail.com";
    github = "ElvishJerricco";
    githubId = 1365692;
    name = "Will Fancher";
  };
  elyhaka = {
    email = "elyhaka@protonmail.com";
    github = "Elyhaka";
    githubId = 57923898;
    name = "Elyhaka";
  };
  em0lar = {
    email = "nix@em0lar.dev";
    github = "em0lar";
    githubId = 11006031;
    name = "Leo Maroni";
  };
  emmanuelrosa = {
    email = "emmanuelrosa@protonmail.com";
    matrix = "@emmanuelrosa:matrix.org";
    github = "emmanuelrosa";
    githubId = 13485450;
    name = "Emmanuel Rosa";
  };
  emptyflask = {
    email = "jon@emptyflask.dev";
    github = "emptyflask";
    githubId = 28287;
    name = "Jon Roberts";
  };
  endgame = {
    email = "jack@jackkelly.name";
    github = "endgame";
    githubId = 231483;
    name = "Jack Kelly";
  };
  enorris = {
    name = "Eric Norris";
    email = "erictnorris@gmail.com";
    github = "ericnorris";
    githubId = 1906605;
  };
  Enteee = {
    email = "nix@duckpond.ch";
    github = "Enteee";
    githubId = 5493775;
    name = "Ente";
  };
  Enzime = {
    email = "enzime@users.noreply.github.com";
    github = "Enzime";
    githubId = 10492681;
    name = "Michael Hoang";
  };
  eonpatapon = {
    email = "eon@patapon.info";
    github = "eonpatapon";
    githubId = 418227;
    name = "Jean-Philippe Braun";
  };
  eperuffo = {
    email = "info@emanueleperuffo.com";
    github = "emanueleperuffo";
    githubId = 5085029;
    name = "Emanuele Peruffo";
  };
  epitrochoid = {
    email = "mpcervin@uncg.edu";
    name = "Mabry Cervin";
  };
  equirosa = {
    email = "eduardo@eduardoquiros.com";
    github = "equirosa";
    githubId = 39096810;
    name = "Eduardo Quiros";
  };
  eqyiel = {
    email = "ruben@maher.fyi";
    github = "eqyiel";
    githubId = 3422442;
    name = "Ruben Maher";
  };
  eraserhd = {
    email = "jason.m.felice@gmail.com";
    github = "eraserhd";
    githubId = 147284;
    name = "Jason Felice";
  };
  erdnaxe = {
    email = "erdnaxe@crans.org";
    github = "erdnaxe";
    githubId = 2663216;
    name = "Alexandre Iooss";
    keys = [{
      longkeyid = "rsa4096/0x6C79278F3FCDCC02";
      fingerprint = "2D37 1AD2 7E2B BC77 97E1  B759 6C79 278F 3FCD CC02";
    }];
  };
  ereslibre = {
    email = "ereslibre@ereslibre.es";
    matrix = "@ereslibre:matrix.org";
    github = "ereslibre";
    githubId = 8706;
    name = "Rafael Fernández López";
  };
  ericbmerritt = {
    email = "eric@afiniate.com";
    github = "ericbmerritt";
    githubId = 4828;
    name = "Eric Merritt";
  };
  ericdallo = {
    email = "ercdll1337@gmail.com";
    github = "ericdallo";
    githubId = 7820865;
    name = "Eric Dallo";
  };
  ericsagnes = {
    email = "eric.sagnes@gmail.com";
    github = "ericsagnes";
    githubId = 367880;
    name = "Eric Sagnes";
  };
  ericson2314 = {
    email = "John.Ericson@Obsidian.Systems";
    matrix = "@ericson2314:matrix.org";
    github = "ericson2314";
    githubId = 1055245;
    name = "John Ericson";
  };
  erictapen = {
    email = "kerstin@erictapen.name";
    github = "erictapen";
    githubId = 11532355;
    name = "Kerstin Humm";
    keys = [{
      longkeyid = "rsa4096/0x40293358C7B9326B";
      fingerprint = "F178 B4B4 6165 6D1B 7C15  B55D 4029 3358 C7B9 326B";
    }];
  };
  erikbackman = {
    email = "contact@ebackman.net";
    github = "erikbackman";
    githubId = 46724898;
    name = "Erik Backman";
  };
  erikryb = {
    email = "erik.rybakken@math.ntnu.no";
    github = "erikryb";
    githubId = 3787281;
    name = "Erik Rybakken";
  };
  erin = {
    name = "Erin van der Veen";
    email = "erin@erinvanderveen.nl";
    github = "ErinvanderVeen";
    githubId = 10973664;
  };
  erosennin = {
    email = "ag@sologoc.com";
    github = "erosennin";
    githubId = 1583484;
    name = "Andrey Golovizin";
  };
  ersin = {
    email = "me@ersinakinci.com";
    github = "earksiinni";
    githubId = 5427394;
    name = "Ersin Akinci";
  };
  ertes = {
    email = "esz@posteo.de";
    github = "ertes";
    githubId = 1855930;
    name = "Ertugrul Söylemez";
  };
  esclear = {
    email = "esclear@users.noreply.github.com";
    github = "esclear";
    githubId = 7432848;
    name = "Daniel Albert";
  };
  eskytthe = {
    email = "eskytthe@gmail.com";
    github = "eskytthe";
    githubId = 2544204;
    name = "Erik Skytthe";
  };
  Esteth = {
    email = "adam.copp@gmail.com";
    name = "Adam Copp";
  };
  ethancedwards8 = {
    email = "ethan@ethancedwards.com";
    github = "ethancedwards8";
    githubId = 60861925;
    name = "Ethan Carter Edwards";
    keys = [{
      longkeyid = "rsa4096/0xF93DDAFA26EF2458";
      fingerprint = "0E69 0F46 3457 D812 3387  C978 F93D DAFA 26EF 2458";
    }];
  };
  ethercrow = {
    email = "ethercrow@gmail.com";
    github = "ethercrow";
    githubId = 222467;
    name = "Dmitry Ivanov";
  };
  etu = {
    email = "elis@hirwing.se";
    matrix = "@etu:semi.social";
    github = "etu";
    githubId = 461970;
    name = "Elis Hirwing";
    keys = [{
      longkeyid = "rsa4096/0xD57EFA625C9A925F";
      fingerprint = "67FE 98F2 8C44 CF22 1828  E12F D57E FA62 5C9A 925F";
    }];
  };
  euank = {
    email = "euank-nixpkg@euank.com";
    github = "euank";
    githubId = 2147649;
    name = "Euan Kemp";
  };
  evalexpr = {
    name = "Jonathan Wilkins";
    email = "nixos@wilkins.tech";
    matrix = "@evalexpr:matrix.org";
    github = "evalexpr";
    githubId = 23485511;
    keys = [{
      longkeyid = "rsa4096/0x2D1D402E17763DD6";
      fingerprint = "8129 5B85 9C5A F703 C2F4  1E29 2D1D 402E 1776 3DD6";
    }];
  };
  evanjs = {
    email = "evanjsx@gmail.com";
    github = "evanjs";
    githubId = 1847524;
    name = "Evan Stoll";
  };
  evax = {
    email = "nixos@evax.fr";
    github = "evax";
    githubId = 599997;
    name = "evax";
  };
  evck = {
    email = "eric@evenchick.com";
    github = "ericevenchick";
    githubId = 195032;
    name = "Eric Evenchick";
  };
  evenbrenden = {
    email = "evenbrenden@gmail.com";
    github = "evenbrenden";
    githubId = 2512008;
    name = "Even Brenden";
  };
  evils = {
    email = "evils.devils@protonmail.com";
    matrix = "@evils:nixos.dev";
    github = "evils";
    githubId = 30512529;
    name = "Evils";
  };
  ewok = {
    email = "ewok@ewok.ru";
    github = "ewok";
    githubId = 454695;
    name = "Artur Taranchiev";
  };
  exarkun = {
    email = "exarkun@twistedmatrix.com";
    github = "exarkun";
    githubId = 254565;
    name = "Jean-Paul Calderone";
  };
  exfalso = {
    email = "0slemi0@gmail.com";
    github = "exfalso";
    githubId = 1042674;
    name = "Andras Slemmer";
  };
  exi = {
    email = "nixos@reckling.org";
    github = "exi";
    githubId = 449463;
    name = "Reno Reckling";
  };
  exlevan = {
    email = "exlevan@gmail.com";
    github = "exlevan";
    githubId = 873530;
    name = "Alexey Levan";
  };
  expipiplus1 = {
    email = "nix@monoid.al";
    matrix = "@ellie:monoid.al";
    github = "expipiplus1";
    githubId = 857308;
    name = "Ellie Hermaszewska";
    keys = [{
      longkeyid = "rsa4096/0xC8116E3A0C1CA76A";
      fingerprint = "FC1D 3E4F CBCA 80DF E870  6397 C811 6E3A 0C1C A76A";
    }];
  };
  extends = {
    email = "sharosari@gmail.com";
    github = "ImExtends";
    githubId = 55919390;
    name = "Vincent VILLIAUMEY";
  };
  eyjhb = {
    email = "eyjhbb@gmail.com";
    matrix = "@eyjhb:eyjhb.dk";
    github = "eyJhb";
    githubId = 25955146;
    name = "eyJhb";
  };
  f--t = {
    email = "git@f-t.me";
    github = "f--t";
    githubId = 2817965;
    name = "f--t";
  };
  f4814n = {
    email = "me@f4814n.de";
    github = "f4814";
    githubId = 11909469;
    name = "Fabian Geiselhart";
  };
  fab = {
    email = "mail@fabian-affolter.ch";
    matrix = "@fabaff:matrix.org";
    name = "Fabian Affolter";
    github = "fabaff";
    githubId = 116184;
    keys = [{
      longkeyid = "dsa1024/0xE23CD2DD36A4397F";
      fingerprint = "2F6C 930F D3C4 7E38 6AFA  4EB4 E23C D2DD 36A4 397F";
    }];
  };
  fabiangd = {
    email = "fabian.g.droege@gmail.com";
    name = "Fabian G. Dröge";
    github = "FabianGD";
    githubId = 40316600;
  };
  fabianhauser = {
    email = "fabian.nixos@fh2.ch";
    github = "fabianhauser";
    githubId = 368799;
    name = "Fabian Hauser";
    keys = [{
      longkeyid = "rsa4096/0x8A52A140BEBF7D2C";
      fingerprint = "50B7 11F4 3DFD 2018 DCE6  E8D0 8A52 A140 BEBF 7D2C";
    }];
  };
  fabianhjr = {
    email = "fabianhjr@protonmail.com";
    github = "fabianhjr";
    githubId = 303897;
    name = "Fabián Heredia Montiel";
  };
  fadenb = {
    email = "tristan.helmich+nixos@gmail.com";
    github = "fadenb";
    githubId = 878822;
    name = "Tristan Helmich";
  };
  falsifian = {
    email = "james.cook@utoronto.ca";
    github = "falsifian";
    githubId = 225893;
    name = "James Cook";
  };
  fare = {
    email = "fahree@gmail.com";
    github = "fare";
    githubId = 8073;
    name = "Francois-Rene Rideau";
  };
  farlion = {
    email = "florian.peter@gmx.at";
    github = "workflow";
    githubId = 1276854;
    name = "Florian Peter";
  };
  fbrs = {
    email = "yuuki@protonmail.com";
    github = "cideM";
    githubId = 4246921;
    name = "Florian Beeres";
  };
  fdns = {
    email = "fdns02@gmail.com";
    github = "fdns";
    githubId = 541748;
    name = "Felipe Espinoza";
  };
  fedx-sudo = {
    email = "fedx-sudo@pm.me";
    github = "Fedx-sudo";
    githubId = 66258975;
    name = "Fedx sudo";
    matrix = "fedx:matrix.org";
  };
  fehnomenal = {
    email = "fehnomenal@fehn.systems";
    github = "fehnomenal";
    githubId = 9959940;
    name = "Andreas Fehn";
  };
  felixscheinost = {
    name = "Felix Scheinost";
    email = "felix.scheinost@posteo.de";
    github = "felixscheinost";
    githubId = 31761492;
  };
  felixsinger = {
    email = "felixsinger@posteo.net";
    github = "felixsinger";
    githubId = 628359;
    name = "Felix Singer";
  };
  felschr = {
    email = "dev@felschr.com";
    matrix = "@felschr:matrix.org";
    github = "felschr";
    githubId = 3314323;
    name = "Felix Tenley";
    keys = [{
      longkeyid = "ed25519/0x910ACB9F6BD26F58";
      fingerprint = "6AB3 7A28 5420 9A41 82D9  0068 910A CB9F 6BD2 6F58";
    }];
  };
  ffinkdevs = {
    email = "fink@h0st.space";
    github = "ffinkdevs";
    githubId = 45924649;
    name = "Fabian Fink";
  };
  fgaz = {
    email = "fgaz@fgaz.me";
    matrix = "@fgaz:matrix.org";
    github = "fgaz";
    githubId = 8182846;
    name = "Francesco Gazzetta";
  };
  figsoda = {
    email = "figsoda@pm.me";
    matrix = "@figsoda:matrix.org";
    github = "figsoda";
    githubId = 40620903;
    name = "figsoda";
  };
  fionera = {
    email = "nix@fionera.de";
    github = "fionera";
    githubId = 5741401;
    name = "Tim Windelschmidt";
  };
  FireyFly = {
    email = "nix@firefly.nu";
    github = "FireyFly";
    githubId = 415760;
    name = "Jonas Höglund";
  };
  fishi0x01 = {
    email = "fishi0x01@gmail.com";
    github = "fishi0x01";
    githubId = 10799507;
    name = "Karl Fischer";
  };
  fitzgibbon = {
    name = "Niall FitzGibbon";
    email = "fitzgibbon.niall@gmail.com";
    github = "fitzgibbon";
    githubId = 617048;
  };
  Flakebi = {
    email = "flakebi@t-online.de";
    github = "Flakebi";
    githubId = 6499211;
    name = "Sebastian Neubauer";
    keys = [{
      longkeyid = "rsa4096/0xECC755EE583C1672";
      fingerprint = "2F93 661D AC17 EA98 A104  F780 ECC7 55EE 583C 1672";
    }];
  };
  flexagoon = {
    email = "flexagoon@pm.me";
    github = "flexagoon";
    githubId = 66178592;
    name = "Pavel Zolotarevskiy";
  };
  flexw = {
    email = "felix.weilbach@t-online.de";
    github = "FlexW";
    githubId = 19961516;
    name = "Felix Weilbach";
  };
  fliegendewurst = {
    email = "arne.keller@posteo.de";
    github = "FliegendeWurst";
    githubId = 12560461;
    name = "Arne Keller";
  };
  flokli = {
    email = "flokli@flokli.de";
    github = "flokli";
    githubId = 183879;
    name = "Florian Klink";
  };
  florentc = {
    email = "florentc@users.noreply.github.com";
    github = "florentc";
    githubId = 1149048;
    name = "Florent Ch.";
  };
  FlorianFranzen = {
    email = "Florian.Franzen@gmail.com";
    github = "FlorianFranzen";
    githubId = 781077;
    name = "Florian Franzen";
  };
  florianjacob = {
    email = "projects+nixos@florianjacob.de";
    github = "florianjacob";
    githubId = 1109959;
    name = "Florian Jacob";
  };
  flosse = {
    email = "mail@markus-kohlhase.de";
    github = "flosse";
    githubId = 276043;
    name = "Markus Kohlhase";
  };
  fluffynukeit = {
    email = "dan@fluffynukeit.com";
    github = "fluffynukeit";
    githubId = 844574;
    name = "Daniel Austin";
  };
  flyfloh = {
    email = "nix@halbmastwurf.de";
    github = "flyfloh";
    githubId = 74379;
    name = "Florian Pester";
  };
  fmthoma = {
    email = "f.m.thoma@googlemail.com";
    github = "fmthoma";
    githubId = 5918766;
    name = "Franz Thoma";
  };
  fooker = {
    email = "fooker@lab.sh";
    github = "fooker";
    githubId = 405105;
    name = "Dustin Frisch";
  };
  forkk = {
    email = "forkk@forkk.net";
    github = "forkk";
    githubId = 1300078;
    name = "Andrew Okin";
  };
  fornever = {
    email = "friedrich@fornever.me";
    github = "fornever";
    githubId = 92793;
    name = "Friedrich von Never";
  };
  fortuneteller2k = {
    email = "lythe1107@gmail.com";
    matrix = "@fortuneteller2k:matrix.org";
    github = "fortuneteller2k";
    githubId = 20619776;
    name = "fortuneteller2k";
  };
  fpletz = {
    email = "fpletz@fnordicwalking.de";
    github = "fpletz";
    githubId = 114159;
    name = "Franz Pletz";
    keys = [{
      longkeyid = "rsa4096/0x846FDED7792617B4";
      fingerprint = "8A39 615D CE78 AF08 2E23  F303 846F DED7 7926 17B4";
    }];
  };
  fps = {
    email = "mista.tapas@gmx.net";
    github = "fps";
    githubId = 84968;
    name = "Florian Paul Schmidt";
  };

  fragamus = {
    email = "innovative.engineer@gmail.com";
    github = "fragamus";
    githubId = 119691;
    name = "Michael Gough";
  };

  fredeb = {
    email = "im@fredeb.dev";
    github = "fredeeb";
    githubId = 7551358;
    name = "Frede Emil";
  };
  freezeboy = {
    email = "freezeboy@users.noreply.github.com";
    github = "freezeboy";
    githubId = 13279982;
    name = "freezeboy";
  };
  Fresheyeball = {
    email = "fresheyeball@gmail.com";
    github = "Fresheyeball";
    githubId = 609279;
    name = "Isaac Shapira";
  };
  fridh = {
    email = "fridh@fridh.nl";
    github = "fridh";
    githubId = 2129135;
    name = "Frederik Rietdijk";
  };
  friedelino = {
    email = "friede.mann@posteo.de";
    github = "friedelino";
    githubId = 46672819;
    name = "Frido Friedemann";
  };
  frlan = {
    email = "frank@frank.uvena.de";
    github = "frlan";
    githubId = 1010248;
    name = "Frank Lanitz";
  };
  fro_ozen = {
    email = "fro_ozen@gmx.de";
    github = "froozen";
    githubId = 1943632;
    name = "fro_ozen";
  };
  frogamic = {
    email = "frogamic@protonmail.com";
    github = "frogamic";
    githubId = 10263813;
    name = "Dominic Shelton";
  };
  Frostman = {
    email = "me@slukjanov.name";
    github = "Frostman";
    githubId = 134872;
    name = "Sergei Lukianov";
  };
  frontsideair = {
    email = "photonia@gmail.com";
    github = "frontsideair";
    githubId = 868283;
    name = "Fatih Altinok";
  };
  ftrvxmtrx = {
    email = "ftrvxmtrx@gmail.com";
    github = "ftrvxmtrx";
    githubId = 248148;
    name = "Sigrid Solveig Haflínudóttir";
  };
  fuerbringer = {
    email = "severin@fuerbringer.info";
    github = "fuerbringer";
    githubId = 10528737;
    name = "Severin Fürbringer";
  };
  fufexan = {
    email = "fufexan@protonmail.com";
    github = "fufexan";
    githubId = 36706276;
    name = "Fufezan Mihai";
  };
  funfunctor = {
    email = "eocallaghan@alterapraxis.com";
    name = "Edward O'Callaghan";
  };
  fusion809 = {
    email = "brentonhorne77@gmail.com";
    github = "fusion809";
    githubId = 4717341;
    name = "Brenton Horne";
  };
  fuuzetsu = {
    email = "fuuzetsu@fuuzetsu.co.uk";
    github = "fuuzetsu";
    githubId = 893115;
    name = "Mateusz Kowalczyk";
  };
  fuwa = {
    email = "echowss@gmail.com";
    github = "fuwa0529";
    githubId = 40521440;
    name = "Haruka Akiyama";
  };
  fuzen = {
    email = "me@fuzen.cafe";
    github = "fuzen-py";
    githubId = 17859309;
    name = "Fuzen";
  };
  fuzzy-id = {
    email = "hacking+nixos@babibo.de";
    name = "Thomas Bach";
  };
  fxfactorial = {
    email = "edgar.factorial@gmail.com";
    github = "fxfactorial";
    githubId = 3036816;
    name = "Edgar Aroutiounian";
  };
  gabesoft = {
    email = "gabesoft@gmail.com";
    github = "gabesoft";
    githubId = 606000;
    name = "Gabriel Adomnicai";
  };
  Gabriel439 = {
    email = "Gabriel439@gmail.com";
    github = "Gabriel439";
    githubId = 1313787;
    name = "Gabriel Gonzalez";
  };
  gador = {
    email = "florian.brandes@posteo.de";
    github = "gador";
    githubId = 1883533;
    name = "Florian Brandes";
    keys = [{
      longkeyid = "rsa4096/0xBBB3E40E53797FD9";
      fingerprint = "0200 3EF8 8D2B CF2D 8F00  FFDC BBB3 E40E 5379 7FD9";
    }];
  };
  gal_bolle = {
    email = "florent.becker@ens-lyon.org";
    github = "FlorentBecker";
    githubId = 7047019;
    name = "Florent Becker";
  };
  galagora = {
    email = "lightningstrikeiv@gmail.com";
    github = "galagora";
    githubId = 45048741;
    name = "Alwanga Oyango";
  };
  gamb = {
    email = "adam.gamble@pm.me";
    github = "gamb";
    githubId = 293586;
    name = "Adam Gamble";
  };
  garbas = {
    email = "rok@garbas.si";
    github = "garbas";
    githubId = 20208;
    name = "Rok Garbas";
  };
  gardspirito = {
    name = "gardspirito";
    email = "nyxoroso@gmail.com";
    github = "gardspirito";
    githubId = 29687558;
  };
  garrison = {
    email = "jim@garrison.cc";
    github = "garrison";
    githubId = 91987;
    name = "Jim Garrison";
  };
  gavin = {
    email = "gavin.rogers@holo.host";
    github = "gavinrogers";
    githubId = 2430469;
    name = "Gavin Rogers";
  };
  gazally = {
    email = "gazally@runbox.com";
    github = "gazally";
    githubId = 16470252;
    name = "Gemini Lasswell";
  };
  gbtb = {
    email = "goodbetterthebeast3@gmail.com";
    github = "gbtb";
    githubId = 37017396;
    name = "gbtb";
  };
  gebner = {
    email = "gebner@gebner.org";
    github = "gebner";
    githubId = 313929;
    name = "Gabriel Ebner";
  };
  genofire = {
    name = "genofire";
    email = "geno+dev@fireorbit.de";
    github = "genofire";
    githubId = 6905586;
    keys = [{
      longkeyid = "rsa4096/0xFC83907C125BC2BC";
      fingerprint = "386E D1BF 848A BB4A 6B4A  3C45 FC83 907C 125B C2BC";
    }];
  };
  georgewhewell = {
    email = "georgerw@gmail.com";
    github = "georgewhewell";
    githubId = 1176131;
    name = "George Whewell";
  };
  georgyo = {
    email = "george@shamm.as";
    github = "georgyo";
    githubId = 19374;
    name = "George Shammas";
    keys = [{
      longkeyid = "rsa4096/0x82BB70D541AE2DB4";
      fingerprint = "D0CF 440A A703 E0F9 73CB  A078 82BB 70D5 41AE 2DB4";
    }];
  };
  gerschtli = {
    email = "tobias.happ@gmx.de";
    github = "Gerschtli";
    githubId = 10353047;
    name = "Tobias Happ";
  };
  gfrascadorio = {
    email = "gfrascadorio@tutanota.com";
    github = "gfrascadorio";
    githubId = 37602871;
    name = "Galois";
  };
  ggpeti = {
    email = "ggpeti@gmail.com";
    matrix = "@ggpeti:ggpeti.com";
    github = "ggpeti";
    githubId = 3217744;
    name = "Peter Ferenczy";
  };
  ghuntley = {
    email = "ghuntley@ghuntley.com";
    github = "ghuntley";
    githubId = 127353;
    name = "Geoffrey Huntley";
  };
  gila = {
    email = "jeffry.molanus@gmail.com";
    github = "gila";
    githubId = 15957973;
    name = "Jeffry Molanus";
  };
  gilligan = {
    email = "tobias.pflug@gmail.com";
    github = "gilligan";
    githubId = 27668;
    name = "Tobias Pflug";
  };
  gin66 = {
    email = "jochen@kiemes.de";
    github = "gin66";
    githubId = 5549373;
    name = "Jochen Kiemes";
  };
  giogadi = {
    email = "lgtorres42@gmail.com";
    github = "giogadi";
    githubId = 1713676;
    name = "Luis G. Torres";
  };
  GKasparov = {
    email = "mizozahr@gmail.com";
    github = "GKasparov";
    githubId = 60962839;
    name = "Mazen Zahr";
  };
  gleber = {
    email = "gleber.p@gmail.com";
    github = "gleber";
    githubId = 33185;
    name = "Gleb Peregud";
  };
  glenns = {
    email = "glenn.searby@gmail.com";
    github = "glenns";
    githubId = 615606;
    name = "Glenn Searby";
  };
  glittershark = {
    name = "Griffin Smith";
    email = "root@gws.fyi";
    github = "glittershark";
    githubId = 1481027;
    keys = [{
      longkeyid = "rsa2048/0x44EF5B5E861C09A7";
      fingerprint = "0F11 A989 879E 8BBB FDC1  E236 44EF 5B5E 861C 09A7";
    }];
  };
  gloaming = {
    email = "ch9871@gmail.com";
    github = "gloaming";
    githubId = 10156748;
    name = "Craig Hall";
  };
  globin = {
    email = "mail@glob.in";
    github = "globin";
    githubId = 1447245;
    name = "Robin Gloster";
  };
  gnxlxnxx = {
    email = "gnxlxnxx@web.de";
    github = "gnxlxnxx";
    githubId = 25820499;
    name = "Roman Kretschmer";
  };
  goertzenator = {
    email = "daniel.goertzen@gmail.com";
    github = "goertzenator";
    githubId = 605072;
    name = "Daniel Goertzen";
  };
  goibhniu = {
    email = "cillian.deroiste@gmail.com";
    github = "cillianderoiste";
    githubId = 643494;
    name = "Cillian de Róiste";
  };
  Gonzih = {
    email = "gonzih@gmail.com";
    github = "Gonzih";
    githubId = 266275;
    name = "Max Gonzih";
  };
  goodrone = {
    email = "goodrone@gmail.com";
    github = "goodrone";
    githubId = 1621335;
    name = "Andrew Trachenko";
  };
  gordias = {
    name = "Gordias";
    email = "gordias@disroot.org";
    github = "gordiasdot";
    githubId = 94724133;
    keys = [{
      longkeyid = "ed25519/0x5D47284830FAA4FA";
      fingerprint = "C006 B8A0 0618 F3B6 E0E4  2ECD 5D47 2848 30FA A4FA";
    }];
  };
  govanify = {
    name = "Gauvain 'GovanifY' Roussel-Tarbouriech";
    email = "gauvain@govanify.com";
    github = "govanify";
    githubId = 6375438;
    keys = [{
      longkeyid = "rsa4096/0xDE62E1E2A6145556";
      fingerprint = "5214 2D39 A7CE F8FA 872B  CA7F DE62 E1E2 A614 5556";
    }];
  };
  gpanders = {
    name = "Gregory Anders";
    email = "greg@gpanders.com";
    github = "gpanders";
    githubId = 8965202;
    keys = [{
      longkeyid = "rsa2048/0x56E93C2FB6B08BDB";
      fingerprint = "B9D5 0EDF E95E ECD0 C135  00A9 56E9 3C2F B6B0 8BDB";
    }];
  };
  gpyh = {
    email = "yacine.hmito@gmail.com";
    github = "yacinehmito";
    githubId = 6893840;
    name = "Yacine Hmito";
  };
  graham33 = {
    email = "graham@grahambennett.org";
    github = "graham33";
    githubId = 10908649;
    name = "Graham Bennett";
  };
  grahamc = {
    email = "graham@grahamc.com";
    github = "grahamc";
    githubId = 76716;
    name = "Graham Christensen";
  };
  gravndal = {
    email = "gaute.ravndal+nixos@gmail.com";
    github = "gravndal";
    githubId = 4656860;
    name = "Gaute Ravndal";
  };
  grburst = {
    email = "GRBurst@protonmail.com";
    github = "GRBurst";
    githubId = 4647221;
    name = "GRBurst";
    keys = [{
      longkeyid = "rsa4096/0x797F623868CD00C2";
      fingerprint = "7FC7 98AB 390E 1646 ED4D  8F1F 797F 6238 68CD 00C2";
    }];
  };
  greizgh = {
    email = "greizgh@ephax.org";
    github = "greizgh";
    githubId = 1313624;
    name = "greizgh";
  };
  greydot = {
    email = "lanablack@amok.cc";
    github = "greydot";
    githubId = 7385287;
    name = "Lana Black";
  };
  gridaphobe = {
    email = "eric@seidel.io";
    github = "gridaphobe";
    githubId = 201997;
    name = "Eric Seidel";
  };
  gspia = {
    email = "iahogsp@gmail.com";
    github = "gspia";
    githubId = 3320792;
    name = "gspia";
  };
  guibert = {
    email = "david.guibert@gmail.com";
    github = "dguibert";
    githubId = 1178864;
    name = "David Guibert";
  };
  groodt = {
    email = "groodt@gmail.com";
    github = "groodt";
    githubId = 343415;
    name = "Greg Roodt";
  };
  gruve-p = {
    email = "groestlcoin@gmail.com";
    github = "gruve-p";
    githubId = 11212268;
    name = "gruve-p";
  };
  gschwartz = {
    email = "gsch@pennmedicine.upenn.edu";
    github = "GregorySchwartz";
    githubId = 2490088;
    name = "Gregory Schwartz";
  };
  gtrunsec = {
    email = "gtrunsec@hardenedlinux.org";
    github = "GTrunSec";
    githubId = 21156405;
    name = "GuangTao Zhang";
  };
  guibou = {
    email = "guillaum.bouchard@gmail.com";
    github = "guibou";
    githubId = 9705357;
    name = "Guillaume Bouchard";
  };
  GuillaumeDesforges = {
    email = "aceus02@gmail.com";
    github = "GuillaumeDesforges";
    githubId = 1882000;
    name = "Guillaume Desforges";
  };
  guillaumekoenig = {
    email = "guillaume.edward.koenig@gmail.com";
    github = "guillaumekoenig";
    githubId = 10654650;
    name = "Guillaume Koenig";
  };
  guserav = {
    email = "guserav@users.noreply.github.com";
    github = "guserav";
    githubId = 28863828;
    name = "guserav";
  };
  guyonvarch = {
    email = "joris@guyonvarch.me";
    github = "guyonvarch";
    githubId = 6768842;
    name = "Joris Guyonvarch";
  };
  gvolpe = {
    email = "volpegabriel@gmail.com";
    github = "gvolpe";
    githubId = 443978;
    name = "Gabriel Volpe";
  };
  gytis-ivaskevicius = {
    name = "Gytis Ivaskevicius";
    email = "me@gytis.io";
    matrix = "@gytis-ivaskevicius:matrix.org";
    github = "gytis-ivaskevicius";
    githubId = 23264966;
  };
  hagl = {
    email = "harald@glie.be";
    github = "hagl";
    githubId = 1162118;
    name = "Harald Gliebe";
  };
  hakuch = {
    email = "hakuch@gmail.com";
    github = "hakuch";
    githubId = 1498782;
    name = "Jesse Haber-Kucharsky";
  };
  hamhut1066 = {
    email = "github@hamhut1066.com";
    github = "moredhel";
    githubId = 1742172;
    name = "Hamish Hutchings";
  };
  hanemile = {
    email = "mail@emile.space";
    github = "hanemile";
    githubId = 22756350;
    name = "Emile Hansmaennel";
  };
  hansjoergschurr = {
    email = "commits@schurr.at";
    github = "hansjoergschurr";
    githubId = 9850776;
    name = "Hans-Jörg Schurr";
  };
  HaoZeke = {
    email = "r95g10@gmail.com";
    github = "haozeke";
    githubId = 4336207;
    name = "Rohit Goswami";
    keys = [{
      longkeyid = "rsa4096/0x9CCCE36402CB49A6";
      fingerprint = "74B1 F67D 8E43 A94A 7554  0768 9CCC E364 02CB 49A6";
    }];
  };
  happysalada = {
    email = "raphael@megzari.com";
    matrix = "@happysalada:matrix.org";
    github = "happysalada";
    githubId = 5317234;
    name = "Raphael Megzari";
  };
  happy-river = {
    email = "happyriver93@runbox.com";
    github = "happy-river";
    githubId = 54728477;
    name = "Happy River";
  };
  hardselius = {
    email = "martin@hardselius.dev";
    github = "hardselius";
    githubId = 1422583;
    name = "Martin Hardselius";
    keys = [{
      longkeyid = "rsa4096/0x03A6E6F786936619";
      fingerprint = "3F35 E4CA CBF4 2DE1 2E90  53E5 03A6 E6F7 8693 6619";
    }];
  };
  haslersn = {
    email = "haslersn@fius.informatik.uni-stuttgart.de";
    github = "haslersn";
    githubId = 33969028;
    name = "Sebastian Hasler";
  };
  havvy = {
    email = "ryan.havvy@gmail.com";
    github = "havvy";
    githubId = 731722;
    name = "Ryan Scheel";
  };
  hawkw = {
    email = "eliza@elizas.website";
    github = "hawkw";
    githubId = 2796466;
    name = "Eliza Weisman";
  };
  hax404 = {
    email = "hax404foogit@hax404.de";
    matrix = "@hax404:hax404.de";
    github = "hax404";
    githubId = 1379411;
    name = "Georg Haas";
  };
  hbunke = {
    email = "bunke.hendrik@gmail.com";
    github = "hbunke";
    githubId = 1768793;
    name = "Hendrik Bunke";
  };
  hce = {
    email = "hc@hcesperer.org";
    github = "hce";
    githubId = 147689;
    name = "Hans-Christian Esperer";
  };
  hdhog = {
    name = "Serg Larchenko";
    email = "hdhog@hdhog.ru";
    github = "hdhog";
    githubId = 386666;
    keys = [{
      longkeyid = "rsa496/952EACB76703BA63";
      fingerprint = "A25F 6321 AAB4 4151 4085  9924 952E ACB7 6703 BA63";
    }];
  };
  hectorj = {
    email = "hector.jusforgues+nixos@gmail.com";
    github = "hectorj";
    githubId = 2427959;
    name = "Hector Jusforgues";
  };
  hedning = {
    email = "torhedinbronner@gmail.com";
    github = "hedning";
    githubId = 71978;
    name = "Tor Hedin Brønner";
  };
  heel = {
    email = "parizhskiy@gmail.com";
    github = "heel";
    githubId = 287769;
    name = "Sergii Paryzhskyi";
  };
  helkafen = {
    email = "arnaudpourseb@gmail.com";
    github = "Helkafen";
    githubId = 2405974;
    name = "Sébastian Méric de Bellefon";
  };
  henkkalkwater = {
    email = "chris+nixpkgs@netsoj.nl";
    github = "HenkKalkwater";
    githubId = 4262067;
    matrix = "@chris:netsoj.nl";
    name = "Chris Josten";
  };
  henrikolsson = {
    email = "henrik@fixme.se";
    github = "henrikolsson";
    githubId = 982322;
    name = "Henrik Olsson";
  };
  henrytill = {
    email = "henrytill@gmail.com";
    github = "henrytill";
    githubId = 6430643;
    name = "Henry Till";
  };
  heph2 = {
    email = "srht@mrkeebs.eu";
    github = "heph2";
    githubId = 87579883;
    name = "Marco";
  };
  herberteuler = {
    email = "herberteuler@gmail.com";
    github = "herberteuler";
    githubId = 1401179;
    name = "Guanpeng Xu";
  };
  hexa = {
    email = "hexa@darmstadt.ccc.de";
    matrix = "@hexa:lossy.network";
    github = "mweinelt";
    githubId = 131599;
    name = "Martin Weinelt";
  };
  hexagonal-sun = {
    email = "dev@mattleach.net";
    github = "hexagonal-sun";
    githubId = 222664;
    name = "Matthew Leach";
  };
  hh = {
    email = "hh@m-labs.hk";
    github = "HarryMakes";
    githubId = 66358631;
    name = "Harry Ho";
  };
  hhm = {
    email = "heehooman+nixpkgs@gmail.com";
    github = "hhm0";
    githubId = 3656888;
    name = "hhm";
  };
  higebu = {
    name = "Yuya Kusakabe";
    email = "yuya.kusakabe@gmail.com";
    github = "higebu";
    githubId = 733288;
  };
  hiljusti = {
    name = "J.R. Hill";
    email = "hiljusti@so.dang.cool";
    github = "hiljusti";
    githubId = 17605298;
  };
  hinton = {
    email = "t@larkery.com";
    name = "Tom Hinton";
  };
  hirenashah = {
    email = "hiren@hiren.io";
    github = "hirenashah";
    githubId = 19825977;
    name = "Hiren Shah";
  };
  hiro98 = {
    email = "hiro@protagon.space";
    github = "vale981";
    githubId = 4025991;
    name = "Valentin Boettcher";
    keys = [{
      longkeyid = "rsa2048/0xC22D4DE4D7B32D19";
      fingerprint = "45A9 9917 578C D629 9F5F  B5B4 C22D 4DE4 D7B3 2D19";
    }];
  };
  hjones2199 = {
    email = "hjones2199@gmail.com";
    github = "hjones2199";
    githubId = 5525217;
    name = "Hunter Jones";
  };
  hkjn = {
    email = "me@hkjn.me";
    name = "Henrik Jonsson";
    github = "hkjn";
    githubId = 287215;
    keys = [{
      longkeyid = "rsa4096/0x03EFBF839A5FDC15";
      fingerprint = "D618 7A03 A40A 3D56 62F5  4B46 03EF BF83 9A5F DC15";
    }];
  };
  hleboulanger = {
    email = "hleboulanger@protonmail.com";
    name = "Harold Leboulanger";
    github = "thbkrhsw";
    githubId = 33122;
  };
  hlolli = {
    email = "hlolli@gmail.com";
    github = "hlolli";
    githubId = 6074754;
    name = "Hlodver Sigurdsson";
  };
  hugoreeves = {
    email = "hugo@hugoreeves.com";
    github = "hugoreeves";
    githubId = 20039091;
    name = "Hugo Reeves";
    keys = [{
      longkeyid = "rsa4096/0x49FA39F8A7F735F9";
      fingerprint = "78C2 E81C 828A 420B 269A  EBC1 49FA 39F8 A7F7 35F9";
    }];
  };
  humancalico = {
    email = "humancalico@disroot.org";
    github = "humancalico";
    githubId = 51334444;
    name = "Akshat Agarwal";
  };
  hodapp = {
    email = "hodapp87@gmail.com";
    github = "Hodapp87";
    githubId = 896431;
    name = "Chris Hodapp";
  };
  hollowman6 = {
    email = "hollowman@hollowman.ml";
    github = "HollowMan6";
    githubId = 43995067;
    name = "Songlin Jiang";
  };
  holymonson = {
    email = "holymonson@gmail.com";
    github = "holymonson";
    githubId = 902012;
    name = "Monson Shao";
  };
  hongchangwu = {
    email = "wuhc85@gmail.com";
    github = "hongchangwu";
    githubId = 362833;
    name = "Hongchang Wu";
  };
  hoppla20 = {
    email = "privat@vincentcui.de";
    github = "hoppla20";
    githubId = 25618740;
    name = "Vincent Cui";
  };
  hoverbear = {
    email = "operator+nix@hoverbear.org";
    matrix = "@hoverbear:matrix.org";
    github = "hoverbear";
    githubId = 130903;
    name = "Ana Hobden";
  };
  holgerpeters = {
    name = "Holger Peters";
    email = "holger.peters@posteo.de";
    github = "HolgerPeters";
    githubId = 4097049;
  };
  hqurve = {
    email = "hqurve@outlook.com";
    github = "hqurve";
    githubId = 53281855;
    name = "hqurve";
  };
  hrdinka = {
    email = "c.nix@hrdinka.at";
    github = "hrdinka";
    githubId = 1436960;
    name = "Christoph Hrdinka";
  };
  hrhino = {
    email = "hora.rhino@gmail.com";
    github = "hrhino";
    githubId = 28076058;
    name = "Harrison Houghton";
  };
  hschaeidt = {
    email = "he.schaeidt@gmail.com";
    github = "hschaeidt";
    githubId = 1614615;
    name = "Hendrik Schaeidt";
  };
  htr = {
    email = "hugo@linux.com";
    github = "htr";
    githubId = 39689;
    name = "Hugo Tavares Reis";
  };
  hugolgst = {
    email = "hugo.lageneste@pm.me";
    github = "hugolgst";
    githubId = 15371828;
    name = "Hugo Lageneste";
  };
  hypersw = {
    email = "baltic@hypersw.net";
    github = "hypersw";
    githubId = 2332070;
    name = "Serge Baltic";
  };
  hyphon81 = {
    email = "zero812n@gmail.com";
    github = "hyphon81";
    githubId = 12491746;
    name = "Masato Yonekawa";
  };
  hyshka = {
    name = "Bryan Hyshka";
    email = "bryan@hyshka.com";
    github = "hyshka";
    githubId = 2090758;
    keys = [{
      longkeyid = "rsa2048/0xDB2D93D1BFAAA6EA";
      fingerprint = "24F4 1925 28C4 8797 E539  F247 DB2D 93D1 BFAA A6EA";
    }];
  };
  hyzual = {
    email = "hyzual@gmail.com";
    github = "Hyzual";
    githubId = 2051507;
    name = "Joris Masson";
  };
  hzeller = {
    email = "h.zeller@acm.org";
    github = "hzeller";
    githubId = 140937;
    name = "Henner Zeller";
  };
  i077 = {
    email = "nixpkgs@imranhossa.in";
    github = "i077";
    githubId = 2789926;
    name = "Imran Hossain";
  };
  iagoq = {
    email = "18238046+iagocq@users.noreply.github.com";
    github = "iagocq";
    githubId = 18238046;
    name = "Iago Manoel Brito";
    keys = [{
      longkeyid = "rsa4096/0x35D39F9A9A1BC8DA";
      fingerprint = "DF90 9D58 BEE4 E73A 1B8C  5AF3 35D3 9F9A 9A1B C8DA";
    }];
  };
  iammrinal0 = {
    email = "nixpkgs@mrinalpurohit.in";
    matrix = "@iammrinal0:nixos.dev";
    github = "iammrinal0";
    githubId = 890062;
    name = "Mrinal";
  };
  iand675 = {
    email = "ian@iankduncan.com";
    github = "iand675";
    githubId = 69209;
    name = "Ian Duncan";
  };
  ianmjones = {
    email = "ian@ianmjones.com";
    github = "ianmjones";
    githubId = 4710;
    name = "Ian M. Jones";
  };
  ianwookim = {
    email = "ianwookim@gmail.com";
    github = "wavewave";
    githubId = 1031119;
    name = "Ian-Woo Kim";
  };
  iblech = {
    email = "iblech@speicherleck.de";
    github = "iblech";
    githubId = 3661115;
    name = "Ingo Blechschmidt";
  };
  icy-thought = {
    name = "Icy-Thought";
    email = "gilganyx@pm.me";
    matrix = "@gilganix:matrix.org";
    github = "Icy-Thought";
    githubId = 53710398;
  };
  idontgetoutmuch = {
    email = "dominic@steinitz.org";
    github = "idontgetoutmuch";
    githubId = 1550265;
    name = "Dominic Steinitz";
  };
  igsha = {
    email = "igor.sharonov@gmail.com";
    github = "igsha";
    githubId = 5345170;
    name = "Igor Sharonov";
  };
  iimog = {
    email = "iimog@iimog.org";
    github = "iimog";
    githubId = 7403236;
    name = "Markus J. Ankenbrand";
  };
  ikervagyok = {
    email = "ikervagyok@gmail.com";
    github = "ikervagyok";
    githubId = 7481521;
    name = "Balázs Lengyel";
  };
  ilian = {
    email = "ilian@tuta.io";
    github = "ilian";
    githubId = 25505957;
    name = "Ilian";
  };
  ilikeavocadoes = {
    email = "ilikeavocadoes@hush.com";
    github = "ilikeavocadoes";
    githubId = 36193715;
    name = "Lassi Haasio";
  };
  ilkecan = {
    email = "ilkecan@protonmail.com";
    matrix = "@ilkecan:matrix.org";
    github = "ilkecan";
    githubId = 40234257;
    name = "ilkecan bozdogan";
  };
  illegalprime = {
    email = "themichaeleden@gmail.com";
    github = "illegalprime";
    githubId = 4401220;
    name = "Michael Eden";
  };
  illiusdope = {
    email = "mat@marini.ca";
    github = "illiusdope";
    githubId = 61913481;
    name = "Mat Marini";
  };
  illustris = {
    email = "me@illustris.tech";
    github = "illustris";
    githubId = 3948275;
    name = "Harikrishnan R";
  };
  ilya-fedin = {
    email = "fedin-ilja2010@ya.ru";
    github = "ilya-fedin";
    githubId = 17829319;
    name = "Ilya Fedin";
  };
  ilya-kolpakov = {
    email = "ilya.kolpakov@gmail.com";
    github = "ilya-kolpakov";
    githubId = 592849;
    name = "Ilya Kolpakov";
  };
  ilyakooo0 = {
    name = "Ilya Kostyuchenko";
    email = "ilyakooo0@gmail.com";
    github = "ilyakooo0";
    githubId = 6209627;
  };
  imalison = {
    email = "IvanMalison@gmail.com";
    github = "IvanMalison";
    githubId = 1246619;
    name = "Ivan Malison";
  };
  imalsogreg = {
    email = "imalsogreg@gmail.com";
    github = "imalsogreg";
    githubId = 993484;
    name = "Greg Hale";
  };
  imgabe = {
    email = "gabrielpmonte@hotmail.com";
    github = "imgabe";
    githubId = 24387926;
    name = "Gabriel Pereira";
  };
  imlonghao = {
    email = "nixos@esd.cc";
    github = "imlonghao";
    githubId = 4951333;
    name = "Hao Long";
  };
  immae = {
    email = "ismael@bouya.org";
    matrix = "@immae:immae.eu";
    github = "immae";
    githubId = 510202;
    name = "Ismaël Bouya";
  };
  imuli = {
    email = "i@imu.li";
    github = "imuli";
    githubId = 4085046;
    name = "Imuli";
  };
  ineol = {
    email = "leo.stefanesco@gmail.com";
    github = "ineol";
    githubId = 37965;
    name = "Léo Stefanesco";
  };
  infinisil = {
    email = "contact@infinisil.com";
    matrix = "@infinisil:matrix.org";
    github = "infinisil";
    githubId = 20525370;
    name = "Silvan Mosberger";
    keys = [{
      longkeyid = "rsa4096/0x422E9EDAE0157170";
      fingerprint = "6C2B 55D4 4E04 8266 6B7D  DA1A 422E 9EDA E015 7170";
    }];
  };
  ingenieroariel = {
    email = "ariel@nunez.co";
    github = "ingenieroariel";
    githubId = 54999;
    name = "Ariel Nunez";
  };
  irenes = {
    name = "Irene Knapp";
    email = "ireneista@gmail.com";
    matrix = "@irenes:matrix.org";
    github = "IreneKnapp";
    githubId = 157678;
    keys = [{
      longkeyid = "rsa4096/0xDBF252AFFB2619FD";
      fingerprint = "E864 BDFA AB55 36FD C905  5195 DBF2 52AF FB26 19FD";
    }];
  };
  ironpinguin = {
    email = "michele@catalano.de";
    github = "ironpinguin";
    githubId = 137306;
    name = "Michele Catalano";
  };
  isgy = {
    name = "isgy";
    email = "isgy@teiyg.com";
    github = "isgy";
    githubId = 13622947;
    keys = [{
      longkeyid = "rsa4096/0xD3E1B013B4631293";
      fingerprint = "1412 816B A9FA F62F D051 1975 D3E1 B013 B463 1293";
    }];
  };
  ius = {
    email = "j.de.gram@gmail.com";
    name = "Joerie de Gram";
    matrix = "@ius:nltrix.net";
    github = "ius";
    githubId = 529626;
  };
  ivan = {
    email = "ivan@ludios.org";
    github = "ivan";
    githubId = 4458;
    name = "Ivan Kozik";
  };
  ivan-babrou = {
    email = "nixpkgs@ivan.computer";
    name = "Ivan Babrou";
    github = "bobrik";
    githubId = 89186;
  };
  ivan-timokhin = {
    email = "nixpkgs@ivan.timokhin.name";
    name = "Ivan Timokhin";
    github = "ivan-timokhin";
    githubId = 9802104;
  };
  ivan-tkatchev = {
    email = "tkatchev@gmail.com";
    name = "Ivan Tkatchev";
  };
  ivanbrennan = {
    email = "ivan.brennan@gmail.com";
    github = "ivanbrennan";
    githubId = 1672874;
    name = "Ivan Brennan";
    keys = [{
      longkeyid = "rsa4096/0x79C3C47DC652EA54";
      fingerprint = "7311 2700 AB4F 4CDF C68C  F6A5 79C3 C47D C652 EA54";
    }];
  };
  ivankovnatsky = {
    email = "75213+ivankovnatsky@users.noreply.github.com";
    github = "ivankovnatsky";
    githubId = 75213;
    name = "Ivan Kovnatsky";
    keys = [{
      longkeyid = "rsa4096/0x3A33FA4C82ED674F";
      fingerprint = "6BD3 7248 30BD 941E 9180  C1A3 3A33 FA4C 82ED 674F";
    }];
  };
  ivar = {
    email = "ivar.scholten@protonmail.com";
    github = "IvarWithoutBones";
    githubId = 41924494;
    name = "Ivar";
  };
  ixmatus = {
    email = "parnell@digitalmentat.com";
    github = "ixmatus";
    githubId = 30714;
    name = "Parnell Springmeyer";
  };
  ixxie = {
    email = "matan@fluxcraft.net";
    github = "ixxie";
    githubId = 20320695;
    name = "Matan Bendix Shenhav";
  };
  izorkin = {
    email = "Izorkin@gmail.com";
    github = "izorkin";
    githubId = 26877687;
    name = "Yurii Izorkin";
  };
  j0xaf = {
    email = "j0xaf@j0xaf.de";
    name = "Jörn Gersdorf";
    github = "j0xaf";
    githubId = 932697;
  };
  j0hax = {
    name = "Johannes Arnold";
    email = "johannes.arnold@stud.uni-hannover.de";
    github = "j0hax";
    githubId = 3802620;
  };
  j4m3s = {
    name = "James Landrein";
    email = "github@j4m3s.eu";
    github = "j4m3s-s";
    githubId = 9413812;
  };
  jacg = {
    name = "Jacek Generowicz";
    email = "jacg@my-post-office.net";
    github = "jacg";
    githubId = 2570854;
  };
  jasoncarr = {
    email = "jcarr250@gmail.com";
    github = "jasoncarr0";
    githubId = 6874204;
    name = "Jason Carr";
  };
  j-brn = {
    email = "me@bricker.io";
    github = "j-brn";
    githubId = 40566146;
    name = "Jonas Braun";
  };
  j-hui = {
    email = "j-hui@cs.columbia.edu";
    github = "j-hui";
    githubId = 11800204;
    name = "John Hui";
  };
  j-keck = {
    email = "jhyphenkeck@gmail.com";
    github = "j-keck";
    githubId = 3081095;
    name = "Jürgen Keck";
  };
  j03 = {
    email = "github@johannesloetzsch.de";
    github = "johannesloetzsch";
    githubId = 175537;
    name = "Johannes Lötzsch";
  };
  jackgerrits = {
    email = "jack@jackgerrits.com";
    github = "jackgerrits";
    githubId = 7558482;
    name = "Jack Gerrits";
  };
  jagajaga = {
    email = "ars.seroka@gmail.com";
    github = "jagajaga";
    githubId = 2179419;
    name = "Arseniy Seroka";
  };
  jakeisnt = {
    name = "Jacob Chvatal";
    email = "jake@isnt.online";
    github = "jakeisnt";
    githubId = 29869612;
  };
  jakelogemann = {
    email = "jake.logemann@gmail.com";
    github = "jakelogemann";
    githubId = 820715;
    name = "Jake Logemann";
  };
  jakestanger = {
    email = "mail@jstanger.dev";
    github = "JakeStanger";
    githubId = 5057870;
    name = "Jake Stanger";
  };
  jakewaksbaum = {
    email = "jake.waksbaum@gmail.com";
    github = "jbaum98";
    githubId = 5283991;
    name = "Jake Waksbaum";
  };
  jakubgs = {
    email = "jakub@gsokolowski.pl";
    github = "jakubgs";
    githubId = 2212681;
    name = "Jakub Grzgorz Sokołowski";
  };
  jamiemagee = {
    email = "jamie.magee@gmail.com";
    github = "JamieMagee";
    githubId = 1358764;
    name = "Jamie Magee";
  };
  jammerful = {
    email = "jammerful@gmail.com";
    github = "jammerful";
    githubId = 20176306;
    name = "jammerful";
  };
  jansol = {
    email = "jan.solanti@paivola.fi";
    github = "jansol";
    githubId = 2588851;
    name = "Jan Solanti";
  };
  jappie = {
    email = "jappieklooster@hotmail.com";
    github = "jappeace";
    githubId = 3874017;
    name = "Jappie Klooster";
  };
  javaguirre = {
    email = "contacto@javaguirre.net";
    github = "javaguirre";
    githubId = 488556;
    name = "Javier Aguirre";
  };
  jb55 = {
    email = "jb55@jb55.com";
    github = "jb55";
    githubId = 45598;
    name = "William Casarin";
  };
  jbcrail = {
    name = "Joseph Crail";
    email = "jbcrail@gmail.com";
    github = "jbcrail";
    githubId = 6038;
  };
  jbedo = {
    email = "cu@cua0.org";
    matrix = "@jb:vk3.wtf";
    github = "jbedo";
    githubId = 372912;
    name = "Justin Bedő";
  };
  jbgi = {
    email = "jb@giraudeau.info";
    github = "jbgi";
    githubId = 221929;
    name = "Jean-Baptiste Giraudeau";
  };
  jceb = {
    name = "jceb";
    email = "jceb@e-jc.de";
    github = "jceb";
    githubId = 101593;
  };
  jchw = {
    email = "johnwchadwick@gmail.com";
    github = "jchv";
    githubId = 938744;
    name = "John Chadwick";
  };
  jcouyang = {
    email = "oyanglulu@gmail.com";
    github = "jcouyang";
    githubId = 1235045;
    name = "Jichao Ouyang";
    keys = [{
      longkeyid = "rsa2048/0xDA8B833B52604E63";
      fingerprint = "A506 C38D 5CC8 47D0 DF01  134A DA8B 833B 5260 4E63";
    }];
  };
  jcumming = {
    email = "jack@mudshark.org";
    github = "jcumming";
    githubId = 1982341;
    name = "Jack Cummings";
  };
  jdagilliland = {
    email = "jdagilliland@gmail.com";
    github = "jdagilliland";
    githubId = 1383440;
    name = "Jason Gilliland";
  };
  jdahm = {
    email = "johann.dahm@gmail.com";
    github = "jdahm";
    githubId = 68032;
    name = "Johann Dahm";
  };
  jdanek = {
    email = "jdanek@redhat.com";
    github = "jdanekrh";
    githubId = 17877663;
    keys = [{
      longkeyid = "ed25519/0x69275CADF15D872E";
      fingerprint = "D4A6 F051 AD58 2E7C BCED  5439 6927 5CAD F15D 872E";
    }];
    name = "Jiri Daněk";
  };
  jdbaldry = {
    email = "jack.baldry@grafana.com";
    github = "jdbaldry";
    githubId = 4599384;
    name = "Jack Baldry";
  };
  jdehaas = {
    email = "qqlq@nullptr.club";
    github = "jeroendehaas";
    githubId = 117874;
    name = "Jeroen de Haas";
  };
  jdreaver = {
    email = "johndreaver@gmail.com";
    github = "jdreaver";
    githubId = 1253071;
    name = "David Reaver";
  };
  jduan = {
    name = "Jingjing Duan";
    email = "duanjingjing@gmail.com";
    github = "jduan";
    githubId = 452450;
  };
  jecaro = {
    email = "jeancharles.quillet@gmail.com";
    github = "jecaro";
    githubId = 17029738;
    name = "Jean-Charles Quillet";
  };
  jefdaj = {
    email = "jefdaj@gmail.com";
    github = "jefdaj";
    githubId = 1198065;
    name = "Jeffrey David Johnson";
  };
  jefflabonte = {
    email = "grimsleepless@protonmail.com";
    github = "jefflabonte";
    githubId = 9425955;
    name = "Jean-François Labonté";
  };
  jensbin = {
    email = "jensbin+git@pm.me";
    github = "jensbin";
    githubId = 1608697;
    name = "Jens Binkert";
  };
  jeremyschlatter = {
    email = "github@jeremyschlatter.com";
    github = "jeremyschlatter";
    githubId = 5741620;
    name = "Jeremy Schlatter";
  };
  jerith666 = {
    email = "github@matt.mchenryfamily.org";
    github = "jerith666";
    githubId = 854319;
    name = "Matt McHenry";
  };
  jeschli = {
    email = "jeschli@gmail.com";
    github = "Jeschli";
    githubId = 10786794;
    name = "Markus Hihn";
  };
  jethro = {
    email = "jethrokuan95@gmail.com";
    github = "jethrokuan";
    githubId = 1667473;
    name = "Jethro Kuan";
  };
  jfb = {
    email = "james@yamtime.com";
    github = "tftio";
    githubId = 143075;
    name = "James Felix Black";
  };
  jflanglois = {
    email = "yourstruly@julienlanglois.me";
    github = "jflanglois";
    githubId = 18501;
    name = "Julien Langlois";
  };
  jfrankenau = {
    email = "johannes@frankenau.net";
    github = "jfrankenau";
    githubId = 2736480;
    name = "Johannes Frankenau";
  };
  jfroche = {
    name = "Jean-François Roche";
    email = "jfroche@pyxel.be";
    matrix = "@jfroche:matrix.pyxel.cloud";
    github = "jfroche";
    githubId = 207369;
    keys = [{
      longkeyid = "dsa1024/0xD1D09DE169EA19A0";
      fingerprint = "7EB1 C02A B62B B464 6D7C  E4AE D1D0 9DE1 69EA 19A0";
    }];
  };
  jgart = {
    email = "jgart@dismail.de";
    github = "jgarte";
    githubId = 47760695;
    name = "Jorge Gomez";
  };
  jgeerds = {
    email = "jascha@geerds.org";
    github = "jgeerds";
    githubId = 1473909;
    name = "Jascha Geerds";
  };
  jgertm = {
    email = "jger.tm@gmail.com";
    github = "jgertm";
    githubId = 6616642;
    name = "Tim Jaeger";
  };
  jgillich = {
    email = "jakob@gillich.me";
    github = "jgillich";
    githubId = 347965;
    name = "Jakob Gillich";
  };
  jglukasik = {
    email = "joseph@jgl.me";
    github = "jglukasik";
    githubId = 6445082;
    name = "Joseph Lukasik";
  };
  jhhuh = {
    email = "jhhuh.note@gmail.com";
    github = "jhhuh";
    githubId = 5843245;
    name = "Ji-Haeng Huh";
  };
  jhillyerd = {
    email = "james+nixos@hillyerd.com";
    github = "jhillyerd";
    githubId = 2502736;
    name = "James Hillyerd";
  };
  jiehong = {
    email = "nixos@majiehong.com";
    github = "Jiehong";
    githubId = 1061229;
    name = "Jiehong Ma";
  };
  jirkamarsik = {
    email = "jiri.marsik89@gmail.com";
    github = "jirkamarsik";
    githubId = 184898;
    name = "Jirka Marsik";
  };
  jitwit = {
    email = "jrn@bluefarm.ca";
    github = "jitwit";
    githubId = 51518420;
    name = "jitwit";
  };
  jjjollyjim = {
    email = "jamie@kwiius.com";
    github = "JJJollyjim";
    githubId = 691552;
    name = "Jamie McClymont";
  };
  jk = {
    email = "hello+nixpkgs@j-k.io";
    matrix = "@j-k:matrix.org";
    github = "06kellyjac";
    githubId = 9866621;
    name = "Jack";
  };
  jkarlson = {
    email = "jekarlson@gmail.com";
    github = "jkarlson";
    githubId = 1204734;
    name = "Emil Karlson";
  };
  jlesquembre = {
    email = "jl@lafuente.me";
    github = "jlesquembre";
    githubId = 1058504;
    name = "José Luis Lafuente";
  };
  jloyet = {
    email = "ml@fatbsd.com";
    github = "fatpat";
    githubId = 822436;
    name = "Jérôme Loyet";
  };
  jluttine = {
    email = "jaakko.luttinen@iki.fi";
    github = "jluttine";
    githubId = 2195834;
    name = "Jaakko Luttinen";
  };
  jm2dev = {
    email = "jomarcar@gmail.com";
    github = "jm2dev";
    githubId = 474643;
    name = "José Miguel Martínez Carrasco";
  };
  jmagnusj = {
    email = "jmagnusj@gmail.com";
    github = "magnusjonsson";
    githubId = 8900;
    name = "Johan Magnus Jonsson";
  };
  jmc-figueira = {
    email = "business+nixos@jmc-figueira.dev";
    github = "jmc-figueira";
    githubId = 6634716;
    name = "João Figueira";
    keys = [
      # GitHub signing key
      {
        longkeyid = "rsa4096/0xDC7AE56AE98E02D7";
        fingerprint = "EC08 7AA3 DEAD A972 F015  6371 DC7A E56A E98E 02D7";
      }
      # Email encryption
      {
        longkeyid = "ed25519/0x197F9A632D139E30";
        fingerprint = "816D 23F5 E672 EC58 7674  4A73 197F 9A63 2D13 9E30";
      }
    ];
  };
  jmettes = {
    email = "jonathan@jmettes.com";
    github = "jmettes";
    githubId = 587870;
    name = "Jonathan Mettes";
  };
  jo1gi = {
    email = "joakimholm@protonmail.com";
    github = "jo1gi";
    githubId = 26695750;
    name = "Joakim Holm";
  };
  joachifm = {
    email = "joachifm@fastmail.fm";
    github = "joachifm";
    githubId = 41977;
    name = "Joachim Fasting";
  };
  joachimschmidt557 = {
    email = "joachim.schmidt557@outlook.com";
    github = "joachimschmidt557";
    githubId = 28556218;
    name = "Joachim Schmidt";
  };
  joamaki = {
    email = "joamaki@gmail.com";
    github = "joamaki";
    githubId = 1102396;
    name = "Jussi Maki";
  };
  jobojeha = {
    email = "jobojeha@jeppener.de";
    github = "jobojeha";
    githubId = 60272884;
    name = "Jonathan Jeppener-Haltenhoff";
  };
  joelancaster = {
    email = "joe.a.lancas@gmail.com";
    github = "joelancaster";
    githubId = 16760945;
    name = "Joe Lancaster";
  };
  joelburget = {
    email = "joelburget@gmail.com";
    github = "joelburget";
    githubId = 310981;
    name = "Joel Burget";
  };
  joelmo = {
    email = "joel.moberg@gmail.com";
    github = "joelmo";
    githubId = 336631;
    name = "Joel Moberg";
  };
  joelteon = {
    email = "me@joelt.io";
    name = "Joel Taylor";
  };
  joepie91 = {
    email = "admin@cryto.net";
    matrix = "@joepie91:pixie.town";
    name = "Sven Slootweg";
    github = "joepie91";
    githubId = 1663259;
  };
  joesalisbury = {
    email = "salisbury.joseph@gmail.com";
    github = "JosephSalisbury";
    githubId = 297653;
    name = "Joe Salisbury";
  };
  johanot = {
    email = "write@ownrisk.dk";
    github = "johanot";
    githubId = 998763;
    name = "Johan Thomsen";
  };
  johbo = {
    email = "johannes@bornhold.name";
    github = "johbo";
    githubId = 117805;
    name = "Johannes Bornhold";
  };
  johnazoidberg = {
    email = "git@danielschaefer.me";
    github = "johnazoidberg";
    githubId = 5307138;
    name = "Daniel Schäfer";
  };
  johnchildren = {
    email = "john.a.children@gmail.com";
    github = "johnchildren";
    githubId = 32305209;
    name = "John Children";
  };
  johnmh = {
    email = "johnmh@openblox.org";
    github = "johnmh";
    githubId = 2576152;
    name = "John M. Harris, Jr.";
  };
  johnramsden = {
    email = "johnramsden@riseup.net";
    github = "johnramsden";
    githubId = 8735102;
    name = "John Ramsden";
  };
  johnrichardrinehart = {
    email = "johnrichardrinehart@gmail.com";
    github = "johnrichardrinehart";
    githubId = 6321578;
    name = "John Rinehart";
  };
  johntitor = {
    email = "huyuumi.dev@gmail.com";
    github = "JohnTitor";
    githubId = 25030997;
    name = "Yuki Okushi";
  };
  jojosch = {
    name = "Johannes Schleifenbaum";
    email = "johannes@js-webcoding.de";
    matrix = "@jojosch:jswc.de";
    github = "jojosch";
    githubId = 327488;
    keys = [{
      longkeyid = "ed25519/059093B1A278BCD0";
      fingerprint = "7249 70E6 A661 D84E 8B47  678A 0590 93B1 A278 BCD0";
    }];
  };
  joko = {
    email = "ioannis.koutras@gmail.com";
    github = "jokogr";
    githubId = 1252547;
    keys = [{
      # compare with https://keybase.io/joko
      longkeyid = "rsa2048/0x85EAE7D9DF56C5CA";
      fingerprint = "B154 A8F9 0610 DB45 0CA8  CF39 85EA E7D9 DF56 C5CA";
    }];
    name = "Ioannis Koutras";
  };
  jonafato = {
    email = "jon@jonafato.com";
    github = "jonafato";
    githubId = 392720;
    name = "Jon Banafato";
  };
  jonathanmarler = {
    email = "johnnymarler@gmail.com";
    github = "marler8997";
    githubId = 304904;
    name = "Jonathan Marler";
  };
  jonathanreeve = {
    email = "jon.reeve@gmail.com";
    github = "JonathanReeve";
    githubId = 1843676;
    name = "Jonathan Reeve";
  };
  jonringer = {
    email = "jonringer117@gmail.com";
    matrix = "@jonringer:matrix.org";
    github = "jonringer";
    githubId = 7673602;
    name = "Jonathan Ringer";
  };
  jorise = {
    email = "info@jorisengbers.nl";
    github = "JorisE";
    githubId = 1767283;
    name = "Joris Engbers";
  };
  jorsn = {
    name = "Johannes Rosenberger";
    email = "johannes@jorsn.eu";
    github = "jorsn";
    githubId = 4646725;
  };
  joshuafern = {
    name = "Joshua Fern";
    email = "joshuafern@protonmail.com";
    github = "JoshuaFern";
    githubId = 4300747;
  };
  jpas = {
    name = "Jarrod Pas";
    email = "jarrod@jarrodpas.com";
    github = "jpas";
    githubId = 5689724;
  };
  jpdoyle = {
    email = "joethedoyle@gmail.com";
    github = "jpdoyle";
    githubId = 1918771;
    name = "Joe Doyle";
  };
  jperras = {
    email = "joel@nerderati.com";
    github = "jperras";
    githubId = 20675;
    name = "Joël Perras";
  };
  jpetrucciani = {
    email = "j@cobi.dev";
    github = "jpetrucciani";
    githubId = 8117202;
    name = "Jacobi Petrucciani";
  };
  jpierre03 = {
    email = "nix@prunetwork.fr";
    github = "jpierre03";
    githubId = 954536;
    name = "Jean-Pierre PRUNARET";
  };
  jpotier = {
    email = "jpo.contributes.to.nixos@marvid.fr";
    github = "jpotier";
    githubId = 752510;
    name = "Martin Potier";
  };
  jqueiroz = {
    email = "nixos@johnjq.com";
    github = "jqueiroz";
    githubId = 4968215;
    name = "Jonathan Queiroz";
  };
  jraygauthier = {
    email = "jraygauthier@gmail.com";
    github = "jraygauthier";
    githubId = 4611077;
    name = "Raymond Gauthier";
  };
  jschievink = {
    email = "jonasschievink@gmail.com";
    matrix = "@jschievink:matrix.org";
    github = "jonas-schievink";
    githubId = 1786438;
    name = "Jonas Schievink";
  };
  jshcmpbll = {
    email = "me@joshuadcampbell.com";
    github = "jshcmpbll";
    githubId = 16374374;
    name = "Joshua Campbell";
  };
  jshholland = {
    email = "josh@inv.alid.pw";
    github = "jshholland";
    githubId = 107689;
    name = "Josh Holland";
  };
  jsierles = {
    email = "joshua@hey.com";
    matrix = "@jsierles:matrix.org";
    name = "Joshua Sierles";
    github = "jsierles";
    githubId = 82;
  };
  jtcoolen = {
    email = "jtcoolen@pm.me";
    name = "Julien Coolen";
    github = "jtcoolen";
    githubId = 54635632;
    keys = [{
      longkeyid = "rsa4096/0x19642151C218F6F5";
      fingerprint = "4C68 56EE DFDA 20FB 77E8  9169 1964 2151 C218 F6F5";
    }];
  };
  jtobin = {
    email = "jared@jtobin.io";
    github = "jtobin";
    githubId = 1414434;
    name = "Jared Tobin";
  };
  jtojnar = {
    email = "jtojnar@gmail.com";
    matrix = "@jtojnar:matrix.org";
    github = "jtojnar";
    githubId = 705123;
    name = "Jan Tojnar";
  };
  juaningan = {
    email = "juaningan@gmail.com";
    github = "uningan";
    githubId = 810075;
    name = "Juan Rodal";
  };
  juliendehos = {
    email = "dehos@lisic.univ-littoral.fr";
    github = "juliendehos";
    githubId = 11947756;
    name = "Julien Dehos";
  };
  julienmalka = {
    email = "julien.malka@me.com";
    github = "JulienMalka";
    githubId = 1792886;
    name = "Julien Malka";
  };
  julm = {
    email = "julm+nixpkgs@sourcephile.fr";
    github = "ju1m";
    githubId = 21160136;
    name = "Julien Moutinho";
  };
  jumper149 = {
    email = "felixspringer149@gmail.com";
    github = "jumper149";
    githubId = 39434424;
    name = "Felix Springer";
  };
  junjihashimoto = {
    email = "junji.hashimoto@gmail.com";
    github = "junjihashimoto";
    githubId = 2469618;
    name = "Junji Hashimoto";
  };
  justinas = {
    email = "justinas@justinas.org";
    github = "justinas";
    githubId = 662666;
    name = "Justinas Stankevičius";
  };
  justinlovinger = {
    email = "git@justinlovinger.com";
    github = "JustinLovinger";
    githubId = 7183441;
    name = "Justin Lovinger";
  };
  justinwoo = {
    email = "moomoowoo@gmail.com";
    github = "justinwoo";
    githubId = 2396926;
    name = "Justin Woo";
  };
  jvanbruegge = {
    email = "supermanitu@gmail.com";
    github = "jvanbruegge";
    githubId = 1529052;
    name = "Jan van Brügge";
    keys = [{
      longkeyid = "rsa4096/0x366572BE7D6C78A2";
      fingerprint = "3513 5CE5 77AD 711F 3825  9A99 3665 72BE 7D6C 78A2";
    }];
  };
  jwatt = {
    email = "jwatt@broken.watch";
    github = "jjwatt";
    githubId = 2397327;
    name = "Jesse Wattenbarger";
  };
  jwiegley = {
    email = "johnw@newartisans.com";
    github = "jwiegley";
    githubId = 8460;
    name = "John Wiegley";
  };
  jwijenbergh = {
    email = "jeroenwijenbergh@protonmail.com";
    github = "jwijenbergh";
    githubId = 46386452;
    name = "Jeroen Wijenbergh";
  };
  jwilberding = {
    email = "jwilberding@afiniate.com";
    name = "Jordan Wilberding";
  };
  jwoudenberg = {
    email = "nixpkgs@jasperwoudenberg.com";
    github = "jwoudenberg";
    githubId = 1525551;
    name = "Jasper Woudenberg";
  };
  jwygoda = {
    email = "jaroslaw@wygoda.me";
    github = "jwygoda";
    githubId = 20658981;
    name = "Jarosław Wygoda";
  };
  jyooru = {
    email = "joel@joel.tokyo";
    github = "jyooru";
    githubId = 63786778;
    name = "Joel";
    keys = [{
      longkeyid = "rsa4096/18550BD205E9EF64";
      fingerprint = "9148 DC9E F4D5 3EB6 A30E  8EF0 1855 0BD2 05E9 EF64";
    }];
  };
  jyp = {
    email = "jeanphilippe.bernardy@gmail.com";
    github = "jyp";
    githubId = 27747;
    name = "Jean-Philippe Bernardy";
  };
  jzellner = {
    email = "jeffz@eml.cc";
    github = "sofuture";
    githubId = 66669;
    name = "Jeff Zellner";
  };
  k4leg = {
    name = "k4leg";
    email = "python.bogdan@gmail.com";
    github = "k4leg";
    githubId = 39882583;
  };
  k900 = {
    name = "Ilya K.";
    email = "me@0upti.me";
    github = "K900";
    githubId = 386765;
    matrix = "@k900:0upti.me";
  };
  kaction = {
    name = "Dmitry Bogatov";
    email = "KAction@disroot.org";
    github = "kaction";
    githubId = 44864956;
    keys = [{
      longkeyid = "ed25519/0x749FD4DFA2E94236";
      fingerprint = "3F87 0A7C A7B4 3731 2F13  6083 749F D4DF A2E9 4236";
    }];
  };
  kaiha = {
    email = "kai.harries@gmail.com";
    github = "kaiha";
    githubId = 6544084;
    name = "Kai Harries";
  };
  kalbasit = {
    email = "wael.nasreddine@gmail.com";
    matrix = "@kalbasit:matrix.org";
    github = "kalbasit";
    githubId = 87115;
    name = "Wael Nasreddine";
  };
  kalekseev = {
    email = "mail@kalekseev.com";
    github = "kalekseev";
    githubId = 367259;
    name = "Konstantin Alekseev";
  };
  kamadorueda = {
    name = "Kevin Amado";
    email = "kamadorueda@gmail.com";
    github = "kamadorueda";
    githubId = 47480384;
    keys = [{
      longkeyid = "rsa4096/0x04D0CEAF916A9A40";
      fingerprint = "2BE3 BAFD 793E A349 ED1F  F00F 04D0 CEAF 916A 9A40";
    }];
  };
  kamilchm = {
    email = "kamil.chm@gmail.com";
    github = "kamilchm";
    githubId = 1621930;
    name = "Kamil Chmielewski";
  };
  kampfschlaefer = {
    email = "arnold@arnoldarts.de";
    github = "kampfschlaefer";
    githubId = 3831860;
    name = "Arnold Krille";
  };
  kanashimia = {
    email = "chad@redpilled.dev";
    github = "kanashimia";
    githubId = 56224949;
    name = "Mia Kanashi";
  };
  karantan = {
    name = "Gasper Vozel";
    email = "karantan@gmail.com";
    github = "karantan";
    githubId = 7062631;
  };
  KarlJoad = {
    email = "karl@hallsby.com";
    github = "KarlJoad";
    githubId = 34152449;
    name = "Karl Hallsby";
  };
  karolchmist = {
    email = "info+nix@chmist.com";
    name = "karolchmist";
  };
  kayhide = {
    email = "kayhide@gmail.com";
    github = "kayhide";
    githubId = 1730718;
    name = "Hideaki Kawai";
  };
  kazcw = {
    email = "kaz@lambdaverse.org";
    github = "kazcw";
    githubId = 1047859;
    name = "Kaz Wesley";
  };
  kcalvinalvin = {
    email = "calvin@kcalvinalvin.info";
    github = "kcalvinalvin";
    githubId = 37185887;
    name = "Calvin Kim";
  };
  kennyballou = {
    email = "kb@devnulllabs.io";
    github = "kennyballou";
    githubId = 2186188;
    name = "Kenny Ballou";
    keys = [{
      longkeyid = "rsa4096/0xB0CAA28A02958308";
      fingerprint = "932F 3E8E 1C0F 4A98 95D7  B8B8 B0CA A28A 0295 8308";
    }];
  };
  kentjames = {
    email = "jameschristopherkent@gmail.com";
    github = "kentjames";
    githubId = 2029444;
    name = "James Kent";
  };
  ketzacoatl = {
    email = "ketzacoatl@protonmail.com";
    github = "ketzacoatl";
    githubId = 10122937;
    name = "ketzacoatl";
  };
  kevincox = {
    email = "kevincox@kevincox.ca";
    matrix = "@kevincox:matrix.org";
    github = "kevincox";
    githubId = 494012;
    name = "Kevin Cox";
  };
  kevingriffin = {
    email = "me@kevin.jp";
    github = "kevingriffin";
    githubId = 209729;
    name = "Kevin Griffin";
  };
  kfollesdal = {
    email = "kfollesdal@gmail.com";
    github = "kfollesdal";
    githubId = 546087;
    name = "Kristoffer K. Føllesdal";
  };
  kho-dialga = {
    email = "ivandashenyou@gmail.com";
    github = "kho-dialga";
    githubId = 55767703;
    name = "Iván Brito";
  };
  khumba = {
    email = "bog@khumba.net";
    github = "khumba";
    githubId = 788813;
    name = "Bryan Gardiner";
  };
  khushraj = {
    email = "khushraj.rathod@gmail.com";
    github = "KhushrajRathod";
    githubId = 44947946;
    name = "Khushraj Rathod";
    keys = [{
      longkeyid = "rsa2048/0xB77B2A40E7702F19";
      fingerprint = "1988 3FD8 EA2E B4EC 0A93  1E22 B77B 2A40 E770 2F19";
    }];
  };
  KibaFox = {
    email = "kiba.fox@foxypossibilities.com";
    github = "KibaFox";
    githubId = 16481032;
    name = "Kiba Fox";
  };
  kidd = {
    email = "raimonster@gmail.com";
    github = "kidd";
    githubId = 25607;
    name = "Raimon Grau";
  };
  kidonng = {
    email = "hi@xuann.wang";
    github = "kidonng";
    githubId = 44045911;
    name = "Kid";
  };
  kierdavis = {
    email = "kierdavis@gmail.com";
    github = "kierdavis";
    githubId = 845652;
    name = "Kier Davis";
  };
  killercup = {
    email = "killercup@gmail.com";
    github = "killercup";
    githubId = 20063;
    name = "Pascal Hertleif";
  };
  kiloreux = {
    email = "kiloreux@gmail.com";
    github = "kiloreux";
    githubId = 6282557;
    name = "Kiloreux Emperex";
  };
  kim0 = {
    email = "email.ahmedkamal@googlemail.com";
    github = "kim0";
    githubId = 59667;
    name = "Ahmed Kamal";
  };
  kimat = {
    email = "mail@kimat.org";
    github = "kimat";
    githubId = 3081769;
    name = "Kimat Boven";
  };
  kimburgess = {
    email = "kim@acaprojects.com";
    github = "kimburgess";
    githubId = 843652;
    name = "Kim Burgess";
  };
  kini = {
    email = "keshav.kini@gmail.com";
    github = "kini";
    githubId = 691290;
    name = "Keshav Kini";
  };
  kirelagin = {
    email = "kirelagin@gmail.com";
    matrix = "@kirelagin:matrix.org";
    github = "kirelagin";
    githubId = 451835;
    name = "Kirill Elagin";
  };
  kirikaza = {
    email = "k@kirikaza.ru";
    github = "kirikaza";
    githubId = 804677;
    name = "Kirill Kazakov";
  };
  kisonecat = {
    email = "kisonecat@gmail.com";
    github = "kisonecat";
    githubId = 148352;
    name = "Jim Fowler";
  };
  kittywitch = {
    email = "kat@kittywit.ch";
    github = "kittywitch";
    githubId = 67870215;
    name = "kat witch";
    keys = [{
      longkeyid = "rsa4096/0x7248991EFA8EFBEE";
      fingerprint = "01F5 0A29 D4AA 9117 5A11  BDB1 7248 991E FA8E FBEE";
    }];
  };
  kiwi = {
    email = "envy1988@gmail.com";
    github = "Kiwi";
    githubId = 35715;
    name = "Robert Djubek";
    keys = [{
      longkeyid = "rsa4096/0x156C88A5B0A04B2A";
      fingerprint = "8992 44FC D291 5CA2 0A97  802C 156C 88A5 B0A0 4B2A";
    }];
  };
  kiyengar = {
    email = "hello@kiyengar.net";
    github = "karthikiyengar";
    githubId = 8260207;
    name = "Karthik Iyengar";
  };
  kjeremy = {
    email = "kjeremy@gmail.com";
    name = "Jeremy Kolb";
    github = "kjeremy";
    githubId = 4325700;
  };
  kkallio = {
    email = "tierpluspluslists@gmail.com";
    name = "Karn Kallio";
  };
  klden = {
    name = "Kenzyme Le";
    email = "kl@kenzymele.com";
    github = "klDen";
    githubId = 5478260;
  };
  klntsky = {
    email = "klntsky@gmail.com";
    name = "Vladimir Kalnitsky";
    github = "klntsky";
    githubId = 18447310;
  };
  kloenk = {
    email = "me@kloenk.de";
    matrix = "@kloenk:petabyte.dev";
    name = "Finn Behrens";
    github = "kloenk";
    githubId = 12898828;
    keys = [{
      longkeyid = "ed25519/0xB92445CFC9546F9D";
      fingerprint = "6881 5A95 D715 D429 659B  48A4 B924 45CF C954 6F9D";
    }];
  };
  kmcopper = {
    email = "kmcopper@danwin1210.me";
    name = "Kyle Copperfield";
    github = "kmcopper";
    githubId = 57132115;
  };
  kmeakin = {
    email = "karlwfmeakin@gmail.com";
    name = "Karl Meakin";
    github = "Kmeakin";
    githubId = 19665139;
  };

  kmein = {
    email = "kmein@posteo.de";
    name = "Kierán Meinhardt";
    github = "kmein";
    githubId = 10352507;
  };
  kmicklas = {
    email = "maintainer@kmicklas.com";
    name = "Ken Micklas";
    github = "kmicklas";
    githubId = 929096;
  };
  knairda = {
    email = "adrian@kummerlaender.eu";
    name = "Adrian Kummerlaender";
    github = "KnairdA";
    githubId = 498373;
  };
  knedlsepp = {
    email = "josef.kemetmueller@gmail.com";
    github = "knedlsepp";
    githubId = 3287933;
    name = "Josef Kemetmüller";
  };
  knl = {
    email = "nikola@knezevic.co";
    github = "knl";
    githubId = 361496;
    name = "Nikola Knežević";
  };
  kolaente = {
    email = "k@knt.li";
    github = "kolaente";
    githubId = 13721712;
    name = "Konrad Langenberg";
  };
  kolbycrouch = {
    email = "kjc.devel@gmail.com";
    github = "kolbycrouch";
    githubId = 6346418;
    name = "Kolby Crouch";
  };
  kolloch = {
    email = "info@eigenvalue.net";
    github = "kolloch";
    githubId = 339354;
    name = "Peter Kolloch";
  };
  konimex = {
    email = "herdiansyah@netc.eu";
    github = "konimex";
    githubId = 15692230;
    name = "Muhammad Herdiansyah";
  };
  koozz = {
    email = "koozz@linux.com";
    github = "koozz";
    githubId = 264372;
    name = "Jan van den Berg";
  };
  koral = {
    email = "koral@mailoo.org";
    github = "k0ral";
    githubId = 524268;
    name = "Koral";
  };
  koslambrou = {
    email = "koslambrou@gmail.com";
    github = "koslambrou";
    githubId = 2037002;
    name = "Konstantinos";
  };
  kovirobi = {
    email = "kovirobi@gmail.com";
    github = "kovirobi";
    githubId = 1903418;
    name = "Kovacsics Robert";
  };
  kquick = {
    email = "quick@sparq.org";
    github = "kquick";
    githubId = 787421;
    name = "Kevin Quick";
  };
  kradalby = {
    name = "Kristoffer Dalby";
    email = "kristoffer@dalby.cc";
    github = "kradalby";
    githubId = 98431;
  };
  kraem = {
    email = "me@kraem.xyz";
    github = "kraem";
    githubId = 26622971;
    name = "Ronnie Ebrin";
  };
  kragniz = {
    email = "louis@kragniz.eu";
    github = "kragniz";
    githubId = 735008;
    name = "Louis Taylor";
  };
  kranzes = {
    email = "personal@ilanjoselevich.com";
    github = "Kranzes";
    githubId = 56614642;
    name = "Ilan Joselevich";
  };
  krav = {
    email = "kristoffer@microdisko.no";
    github = "krav";
    githubId = 4032;
    name = "Kristoffer Thømt Ravneberg";
  };
  kritnich = {
    email = "kritnich@kritni.ch";
    github = "Kritnich";
    githubId = 22116767;
    name = "Kritnich";
  };
  kroell = {
    email = "nixosmainter@makroell.de";
    github = "rokk4";
    githubId = 17659803;
    name = "Matthias Axel Kröll";
  };
  kristian-brucaj = {
    email = "kbrucaj@gmail.com";
    github = "kristian-brucaj";
    githubId = 8893110;
    name = "Kristian Brucaj";
  };
  kristoff3r = {
    email = "k.soeholm@gmail.com";
    github = "kristoff3r";
    githubId = 160317;
    name = "Kristoffer Søholm";
  };
  ktf = {
    email = "giulio.eulisse@cern.ch";
    github = "ktf";
    githubId = 10544;
    name = "Giuluo Eulisse";
  };
  kthielen = {
    email = "kthielen@gmail.com";
    github = "kthielen";
    githubId = 1409287;
    name = "Kalani Thielen";
  };
  ktor = {
    email = "kruszewsky@gmail.com";
    github = "ktor";
    githubId = 99639;
    name = "Pawel Kruszewski";
  };
  ktosiek = {
    email = "tomasz.kontusz@gmail.com";
    github = "ktosiek";
    githubId = 278013;
    name = "Tomasz Kontusz";
  };
  kubukoz = {
    email = "kubukoz@gmail.com";
    github = "kubukoz";
    githubId = 894884;
    name = "Jakub Kozłowski";
  };
  kurnevsky = {
    email = "kurnevsky@gmail.com";
    github = "kurnevsky";
    githubId = 2943605;
    name = "Evgeny Kurnevsky";
  };
  kuznero = {
    email = "roman@kuznero.com";
    github = "kuznero";
    githubId = 449813;
    name = "Roman Kuznetsov";
  };
  kvark = {
    name = "Dzmitry Malyshau";
    email = "kvark@fastmail.com";
    matrix = "@kvark:matrix.org";
    github = "kvark";
    githubId = 107301;
  };
  kwohlfahrt = {
    email = "kai.wohlfahrt@gmail.com";
    github = "kwohlfahrt";
    githubId = 2422454;
    name = "Kai Wohlfahrt";
  };
  kyleondy = {
    email = "kyle@ondy.org";
    github = "kyleondy";
    githubId = 1640900;
    name = "Kyle Ondy";
    keys = [{
      longkeyid = "rsa4096/0xDB0E3C33491F91C9";
      fingerprint = "3C79 9D26 057B 64E6 D907  B0AC DB0E 3C33 491F 91C9";
    }];
  };
  kylesferrazza = {
    name = "Kyle Sferrazza";
    email = "nixpkgs@kylesferrazza.com";

    github = "kylesferrazza";
    githubId = 6677292;

    keys = [{
      longkeyid = "rsa4096/81A1540948162372";
      fingerprint = "5A9A 1C9B 2369 8049 3B48  CF5B 81A1 5409 4816 2372";
    }];
  };
  l-as = {
    email = "las@protonmail.ch";
    matrix = "@Las:matrix.org";
    github = "L-as";
    githubId = 22075344;
    keys = [{
      longkeyid = "rsa2048/0xAC458A7D1087D025";
      fingerprint = "A093 EA17 F450 D4D1 60A0  1194 AC45 8A7D 1087 D025";
    }];
    name = "Las Safin";
  };
  l3af = {
    email = "L3afMeAlon3@gmail.com";
    matrix = "@L3afMe:matrix.org";
    github = "L3afMe";
    githubId = 72546287;
    name = "L3af";
  };
  lach = {
    email = "iam@lach.pw";
    github = "CertainLach";
    githubId = 6235312;
    keys = [{
      longkeyid = "rsa3072/40B5D6948143175F";
      fingerprint = "323C 95B5 DBF7 2D74 8570  C0B7 40B5 D694 8143 175F";
    }];
    name = "Yaroslav Bolyukin";
  };
  laikq = {
    email = "gwen@quasebarth.de";
    github = "laikq";
    githubId = 55911173;
    name = "Gwendolyn Quasebarth";
  };
  lammermann = {
    email = "k.o.b.e.r@web.de";
    github = "lammermann";
    githubId = 695526;
    name = "Benjamin Kober";
  };
  larsr = {
    email = "Lars.Rasmusson@gmail.com";
    github = "larsr";
    githubId = 182024;
    name = "Lars Rasmusson";
  };
  lasandell = {
    email = "lasandell@gmail.com";
    github = "lasandell";
    githubId = 2034420;
    name = "Luke Sandell";
  };
  lambda-11235 = {
    email = "taranlynn0@gmail.com";
    github = "lambda-11235";
    githubId = 16354815;
    name = "Taran Lynn";
  };
  lassulus = {
    email = "lassulus@gmail.com";
    matrix = "@lassulus:nixos.dev";
    github = "Lassulus";
    githubId = 621759;
    name = "Lassulus";
  };
  lattfein = {
    email = "lattfein@gmail.com";
    # Their GitHub account was deleted.
    #
    # See: https://github.com/NixOS/nixpkgs/pull/69007 where this
    # was added but is now owned by a ghost.
    #
    # Possibly the username lattfein (currently github ID 56827487) is
    # owned by the same person, but we should confirm before adding
    # the GitHub name or ID back.
    # github = "lattfein";
    name = "Koki Yasuno";
  };
  layus = {
    email = "layus.on@gmail.com";
    github = "layus";
    githubId = 632767;
    name = "Guillaume Maudoux";
  };
  lblasc = {
    email = "lblasc@znode.net";
    github = "lblasc";
    githubId = 32152;
    name = "Luka Blaskovic";
  };
  lbpdt = {
    email = "nix@pdtpartners.com";
    github = "lbpdt";
    githubId = 45168934;
    name = "Louis Blin";
  };
  lucc = {
    email = "lucc+nix@posteo.de";
    github = "lucc";
    githubId = 1104419;
    name = "Lucas Hoffmann";
  };
  lucasew = {
    email = "lucas59356@gmail.com";
    github = "lucasew";
    githubId = 15693688;
    name = "Lucas Eduardo Wendt";
  };
  lde = {
    email = "lilian.deloche@puck.fr";
    github = "lde";
    githubId = 1447020;
    name = "Lilian Deloche";
  };
  ldelelis = {
    email = "ldelelis@est.frba.utn.edu.ar";
    github = "ldelelis";
    githubId = 20250323;
    name = "Lucio Delelis";
  };
  ldenefle = {
    email = "ldenefle@gmail.com";
    github = "ldenefle";
    githubId = 20558127;
    name = "Lucas Denefle";
  };
  ldesgoui = {
    email = "ldesgoui@gmail.com";
    matrix = "@ldesgoui:matrix.org";
    github = "ldesgoui";
    githubId = 2472678;
    name = "Lucas Desgouilles";
  };
  league = {
    email = "league@contrapunctus.net";
    github = "league";
    githubId = 50286;
    name = "Christopher League";
  };
  leahneukirchen = {
    email = "leah@vuxu.org";
    github = "leahneukirchen";
    githubId = 139;
    name = "Leah Neukirchen";
  };
  lebastr = {
    email = "lebastr@gmail.com";
    github = "lebastr";
    githubId = 887072;
    name = "Alexander Lebedev";
  };
  ledif = {
    email = "refuse@gmail.com";
    github = "ledif";
    githubId = 307744;
    name = "Adam Fidel";
  };
  leemachin = {
    email = "me@mrl.ee";
    github = "leemachin";
    githubId = 736291;
    name = "Lee Machin";
  };
  leenaars = {
    email = "ml.software@leenaa.rs";
    github = "leenaars";
    githubId = 4158274;
    name = "Michiel Leenaars";
  };
  lom = {
    email = "legendofmiracles@protonmail.com";
    matrix = "@legendofmiracles:matrix.org";
    github = "legendofmiracles";
    githubId = 30902201;
    name = "legendofmiracles";
    keys = [{
      longkeyid = "rsa4096/0x19B082B3DEFE5451";
      fingerprint = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
    }];
  };
  leixb = {
    email = "abone9999+nixpkgs@gmail.com";
    matrix = "@leix_b:matrix.org";
    github = "LeixB";
    githubId = 17183803;
    name = "Aleix Boné";
    keys = [{
      longkeyid = "rsa4096/0xFC035BB2BB28E15D";
      fingerprint = "63D3 F436 EDE8 7E1F 1292  24AF FC03 5BB2 BB28 E15D";
    }];
  };
  lejonet = {
    email = "daniel@kuehn.se";
    github = "lejonet";
    githubId = 567634;
    name = "Daniel Kuehn";
  };
  leo60228 = {
    email = "iakornfeld@gmail.com";
    github = "leo60228";
    githubId = 8355305;
    name = "leo60228";
  };
  leonardoce = {
    email = "leonardo.cecchi@gmail.com";
    github = "leonardoce";
    githubId = 1572058;
    name = "Leonardo Cecchi";
  };
  leshainc = {
    email = "leshainc@fomalhaut.me";
    github = "LeshaInc";
    githubId = 42153076;
    name = "Alexey Nikashkin";
  };
  lesuisse = {
    email = "thomas@gerbet.me";
    github = "LeSuisse";
    githubId = 737767;
    name = "Thomas Gerbet";
  };
  lethalman = {
    email = "lucabru@src.gnome.org";
    github = "lethalman";
    githubId = 480920;
    name = "Luca Bruno";
  };
  leungbk = {
    email = "leungbk@mailfence.com";
    github = "leungbk";
    githubId = 29217594;
    name = "Brian Leung";
  };
  lewo = {
    email = "lewo@abesis.fr";
    matrix = "@lewo:matrix.org";
    github = "nlewo";
    githubId = 3425311;
    name = "Antoine Eiche";
  };
  lexuge = {
    name = "Harry Ying";
    email = "lexugeyky@outlook.com";
    github = "LEXUGE";
    githubId = 13804737;
    keys = [{
      longkeyid = "rsa4096/0xAE53B4C2E58EDD45";
      fingerprint = "7FE2 113A A08B 695A C8B8  DDE6 AE53 B4C2 E58E DD45";
    }];
  };
  lf- = {
    email = "nix-maint@lfcode.ca";
    github = "lf-";
    githubId = 6652840;
    name = "Jade";
  };
  lgcl = {
    email = "dev@lgcl.de";
    name = "Leon Vack";
    github = "LogicalOverflow";
    githubId = 5919957;
  };
  lheckemann = {
    email = "git@sphalerite.org";
    github = "lheckemann";
    githubId = 341954;
    name = "Linus Heckemann";
  };
  lhvwb = {
    email = "nathaniel.baxter@gmail.com";
    github = "nathanielbaxter";
    githubId = 307589;
    name = "Nathaniel Baxter";
  };
  liamdiprose = {
    email = "liam@liamdiprose.com";
    github = "liamdiprose";
    githubId = 1769386;
    name = "Liam Diprose";
  };
  liff = {
    email = "liff@iki.fi";
    github = "liff";
    githubId = 124475;
    name = "Olli Helenius";
  };
  lightbulbjim = {
    email = "chris@killred.net";
    github = "lightbulbjim";
    githubId = 4312404;
    name = "Chris Rendle-Short";
  };
  lightdiscord = {
    email = "root@arnaud.sh";
    github = "lightdiscord";
    githubId = 24509182;
    name = "Arnaud Pascal";
  };
  lihop = {
    email = "nixos@leroy.geek.nz";
    github = "lihop";
    githubId = 3696783;
    name = "Leroy Hopson";
  };
  lilyball = {
    email = "lily@sb.org";
    github = "lilyball";
    githubId = 714;
    name = "Lily Ballard";
  };
  limeytexan = {
    email = "limeytexan@gmail.com";
    github = "limeytexan";
    githubId = 36448130;
    name = "Michael Brantley";
  };
  linarcx = {
    email = "linarcx@gmail.com";
    github = "linarcx";
    githubId = 10884422;
    name = "Kaveh Ahangar";
  };
  linc01n = {
    email = "git@lincoln.hk";
    github = "linc01n";
    githubId = 667272;
    name = "Lincoln Lee";
  };
  linquize = {
    email = "linquize@yahoo.com.hk";
    github = "linquize";
    githubId = 791115;
    name = "Linquize";
  };
  linsui = {
    email = "linsui555@gmail.com";
    github = "linsui";
    githubId = 36977733;
    name = "linsui";
  };
  linus = {
    email = "linusarver@gmail.com";
    github = "listx";
    githubId = 725613;
    name = "Linus Arver";
  };
  livnev = {
    email = "lev@liv.nev.org.uk";
    github = "livnev";
    githubId = 3964494;
    name = "Lev Livnev";
    keys = [{
      longkeyid = "rsa2048/0x68FF81E6A7850F49";
      fingerprint = "74F5 E5CC 19D3 B5CB 608F  6124 68FF 81E6 A785 0F49";
    }];
  };
  lourkeur = {
    name = "Louis Bettens";
    email = "louis@bettens.info";
    github = "lourkeur";
    githubId = 15657735;
    keys = [{
      longkeyid = "ed25519/0xDFE1D4A017337E2A";
      fingerprint = "5B93 9CFA E8FC 4D8F E07A  3AEA DFE1 D4A0 1733 7E2A";
    }];
  };
  lorenzleutgeb = {
    email = "lorenz@leutgeb.xyz";
    github = "lorenzleutgeb";
    githubId = 542154;
    name = "Lorenz Leutgeb";
  };
  luis = {
    email = "luis.nixos@gmail.com";
    github = "Luis-Hebendanz";
    githubId = 22085373;
    name = "Luis Hebendanz";
  };
  lunarequest = {
    email = "nullarequest@vivlaid.net";
    github = "Lunarequest";
    githubId = 30698906;
    name = "Luna D Dragon";
  };
  lionello = {
    email = "lio@lunesu.com";
    github = "lionello";
    githubId = 591860;
    name = "Lionello Lunesu";
  };
  lluchs = {
    email = "lukas.werling@gmail.com";
    github = "lluchs";
    githubId = 516527;
    name = "Lukas Werling";
  };
  lnl7 = {
    email = "daiderd@gmail.com";
    github = "lnl7";
    githubId = 689294;
    name = "Daiderd Jordan";
  };
  lo1tuma = {
    email = "schreck.mathias@gmail.com";
    github = "lo1tuma";
    githubId = 169170;
    name = "Mathias Schreck";
  };
  loewenheim = {
    email = "loewenheim@mailbox.org";
    github = "loewenheim";
    githubId = 7622248;
    name = "Sebastian Zivota";
  };
  locallycompact = {
    email = "dan.firth@homotopic.tech";
    github = "locallycompact";
    githubId = 1267527;
    name = "Daniel Firth";
  };
  lopsided98 = {
    email = "benwolsieffer@gmail.com";
    github = "lopsided98";
    githubId = 5624721;
    name = "Ben Wolsieffer";
  };
  loskutov = {
    email = "ignat.loskutov@gmail.com";
    github = "loskutov";
    githubId = 1202012;
    name = "Ignat Loskutov";
  };
  lostnet = {
    email = "lost.networking@gmail.com";
    github = "lostnet";
    githubId = 1422781;
    name = "Will Young";
  };
  louisdk1 = {
    email = "louis@louis.dk";
    github = "louisdk1";
    githubId = 4969294;
    name = "Louis Tim Larsen";
  };
  lovek323 = {
    email = "jason@oconal.id.au";
    github = "lovek323";
    githubId = 265084;
    name = "Jason O'Conal";
  };
  lovesegfault = {
    email = "meurerbernardo@gmail.com";
    matrix = "@lovesegfault:matrix.org";
    github = "lovesegfault";
    githubId = 7243783;
    name = "Bernardo Meurer";
    keys = [{
      longkeyid = "rsa4096/0xF4C0D53B8D14C246";
      fingerprint = "F193 7596 57D5 6DA4 CCD4  786B F4C0 D53B 8D14 C246";
    }];
  };
  lowfatcomputing = {
    email = "andreas.wagner@lowfatcomputing.org";
    github = "lowfatcomputing";
    githubId = 10626;
    name = "Andreas Wagner";
  };
  lrewega = {
    email = "lrewega@c32.ca";
    github = "lrewega";
    githubId = 639066;
    name = "Luke Rewega";
  };
  lromor = {
    email = "leonardo.romor@gmail.com";
    github = "lromor";
    githubId = 1597330;
    name = "Leonardo Romor";
  };
  lrworth = {
    email = "luke@worth.id.au";
    name = "Luke Worth";
  };
  lschuermann = {
    email = "leon.git@is.currently.online";
    matrix = "@leons:is.currently.online";
    github = "lschuermann";
    githubId = 5341193;
    name = "Leon Schuermann";
  };
  lsix = {
    email = "lsix@lancelotsix.com";
    github = "lsix";
    githubId = 724339;
    name = "Lancelot SIX";
  };
  ltavard = {
    email = "laure.tavard@univ-grenoble-alpes.fr";
    github = "ltavard";
    githubId = 8555953;
    name = "Laure Tavard";
  };
  luc65r = {
    email = "lucas@ransan.tk";
    github = "luc65r";
    githubId = 59375051;
    name = "Lucas Ransan";
  };
  lucperkins = {
    email = "lucperkins@gmail.com";
    github = "lucperkins";
    githubId = 1523104;
    name = "Luc Perkins";
  };
  lucus16 = {
    email = "lars.jellema@gmail.com";
    github = "Lucus16";
    githubId = 2487922;
    name = "Lars Jellema";
  };
  ludo = {
    email = "ludo@gnu.org";
    github = "civodul";
    githubId = 1168435;
    name = "Ludovic Courtès";
  };
  lufia = {
    email = "lufia@lufia.org";
    github = "lufia";
    githubId = 1784379;
    name = "Kyohei Kadota";
  };
  Luflosi = {
    name = "Luflosi";
    email = "luflosi@luflosi.de";
    github = "Luflosi";
    githubId = 15217907;
    keys = [{
      longkeyid = "rsa4096/0x6F987CCF224D20B9";
      fingerprint = "66D1 3048 2B5F 2069 81A6  6B83 6F98 7CCF 224D 20B9";
    }];
  };
  luispedro = {
    email = "luis@luispedro.org";
    github = "luispedro";
    githubId = 79334;
    name = "Luis Pedro Coelho";
  };
  lukeadams = {
    email = "luke.adams@belljar.io";
    github = "lukeadams";
    githubId = 3508077;
    name = "Luke Adams";
  };
  lukebfox = {
    email = "lbentley-fox1@sheffield.ac.uk";
    github = "lukebfox";
    githubId = 34683288;
    name = "Luke Bentley-Fox";
  };
  lukegb = {
    email = "nix@lukegb.com";
    matrix = "@lukegb:zxcvbnm.ninja";
    github = "lukegb";
    githubId = 246745;
    name = "Luke Granger-Brown";
  };
  lukego = {
    email = "luke@snabb.co";
    github = "lukego";
    githubId = 13791;
    name = "Luke Gorrie";
  };
  luker = {
    email = "luker@fenrirproject.org";
    github = "LucaFulchir";
    githubId = 2486026;
    name = "Luca Fulchir";
  };
  lumi = {
    email = "lumi@pew.im";
    github = "lumi-me-not";
    githubId = 26020062;
    name = "lumi";
  };
  lunik1 = {
    email = "ch.nixpkgs@themaw.xyz";
    matrix = "@lunik1:lunik.one";
    github = "lunik1";
    githubId = 13547699;
    name = "Corin Hoad";
    keys = [{
      longkeyid = "rsa2048/0x6A37DF9483188492";
      fingerprint = "BA3A 5886 AE6D 526E 20B4  57D6 6A37 DF94 8318 8492";
    }];
  };
  lux = {
    email = "lux@lux.name";
    githubId = 1208273;
    matrix = "@lux:ontheblueplanet.com";
    name = "Lux";
  };
  luz = {
    email = "luz666@daum.net";
    github = "Luz";
    githubId = 208297;
    name = "Luz";
  };
  lw = {
    email = "lw@fmap.me";
    github = "lolwat97";
    githubId = 2057309;
    name = "Sergey Sofeychuk";
  };
  lxea = {
    email = "nix@amk.ie";
    github = "lxea";
    githubId = 7910815;
    name = "Alex McGrath";
  };
  lynty = {
    email = "ltdong93+nix@gmail.com";
    github = "lynty";
    githubId = 39707188;
    name = "Lynn Dong";
  };
  lyt = {
    email = "wheatdoge@gmail.com";
    name = "Tim Liou";
  };
  m00wl = {
    name = "Moritz Lumme";
    email = "moritz.lumme@gmail.com";
    github = "m00wl";
    githubId = 46034439;
  };
  m1cr0man = {
    email = "lucas+nix@m1cr0man.com";
    github = "m1cr0man";
    githubId = 3044438;
    name = "Lucas Savva";
  };
  m3tti = {
    email = "mathaeus.peter.sander@gmail.com";
    name = "Mathaeus Sander";
  };
  ma27 = {
    email = "maximilian@mbosch.me";
    matrix = "@ma27:nicht-so.sexy";
    github = "ma27";
    githubId = 6025220;
    name = "Maximilian Bosch";
  };
  ma9e = {
    email = "sean@lfo.team";
    github = "furrycatherder";
    githubId = 36235154;
    name = "Sean Haugh";
  };
  maaslalani = {
    email = "maaslalani0@gmail.com";
    github = "maaslalani";
    githubId = 42545625;
    name = "Maas Lalani";
  };
  madjar = {
    email = "georges.dubus@compiletoi.net";
    github = "madjar";
    githubId = 109141;
    name = "Georges Dubus";
  };
  Madouura = {
    email = "madouura@gmail.com";
    github = "Madouura";
    githubId = 93990818;
    name = "Madoura";
  };
  mafo = {
    email = "Marc.Fontaine@gmx.de";
    github = "MarcFontaine";
    githubId = 1433367;
    name = "Marc Fontaine";
  };
  magenbluten = {
    email = "magenbluten@codemonkey.cc";
    github = "magenbluten";
    githubId = 1140462;
    name = "magenbluten";
  };
  magnetophon = {
    email = "bart@magnetophon.nl";
    github = "magnetophon";
    githubId = 7645711;
    name = "Bart Brouns";
  };
  mahe = {
    email = "matthias.mh.herrmann@gmail.com";
    github = "2chilled";
    githubId = 1238350;
    name = "Matthias Herrmann";
  };
  majesticmullet = {
    email = "hoccthomas@gmail.com.au";
    github = "MajesticMullet";
    githubId = 31056089;
    name = "Tom Ho";
  };
  makefu = {
    email = "makefu@syntax-fehler.de";
    github = "makefu";
    githubId = 115218;
    name = "Felix Richter";
  };
  malo = {
    email = "mbourgon@gmail.com";
    github = "malob";
    githubId = 2914269;
    name = "Malo Bourgon";
  };
  malvo = {
    email = "malte@malvo.org";
    github = "malte-v";
    githubId = 34393802;
    name = "Malte Voos";
  };
  malbarbo = {
    email = "malbarbo@gmail.com";
    github = "malbarbo";
    githubId = 1678126;
    name = "Marco A L Barbosa";
  };
  malyn = {
    email = "malyn@strangeGizmo.com";
    github = "malyn";
    githubId = 346094;
    name = "Michael Alyn Miller";
  };
  manojkarthick = {
    email = "smanojkarthick@gmail.com";
    github = "manojkarthick";
    githubId = 7802795;
    name = "Manoj Karthick";
  };
  manveru = {
    email = "m.fellinger@gmail.com";
    matrix = "@manveru:matrix.org";
    github = "manveru";
    githubId = 3507;
    name = "Michael Fellinger";
  };
  maralorn = {
    email = "malte.brandy@maralorn.de";
    matrix = "@maralorn:maralorn.de";
    github = "maralorn";
    githubId = 1651325;
    name = "Malte Brandy";
  };
  marcweber = {
    email = "marco-oweber@gmx.de";
    github = "marcweber";
    githubId = 34086;
    name = "Marc Weber";
  };
  marcus7070 = {
    email = "marcus@geosol.com.au";
    github = "marcus7070";
    githubId = 50230945;
    name = "Marcus Boyd";
  };
  marenz = {
    email = "marenz@arkom.men";
    github = "marenz2569";
    githubId = 12773269;
    name = "Markus Schmidl";
  };
  markus1189 = {
    email = "markus1189@gmail.com";
    github = "markus1189";
    githubId = 591567;
    name = "Markus Hauck";
  };
  markuskowa = {
    email = "markus.kowalewski@gmail.com";
    github = "markuskowa";
    githubId = 26470037;
    name = "Markus Kowalewski";
  };
  markWot = {
    email = "markus@wotringer.de";
    name = "Markus Wotringer";
  };
  marijanp = {
    name = "Marijan Petričević";
    email = "marijan.petricevic94@gmail.com";
    github = "marijanp";
    githubId = 13599169;
  };
  marius851000 = {
    email = "mariusdavid@laposte.net";
    name = "Marius David";
    github = "marius851000";
    githubId = 22586596;
  };
  marsam = {
    email = "marsam@users.noreply.github.com";
    github = "marsam";
    githubId = 65531;
    name = "Mario Rodas";
  };
  martijnvermaat = {
    email = "martijn@vermaat.name";
    github = "martijnvermaat";
    githubId = 623509;
    name = "Martijn Vermaat";
  };
  martinetd = {
    email = "f.ktfhrvnznqxacf@noclue.notk.org";
    github = "martinetd";
    githubId = 1729331;
    name = "Dominique Martinet";
  };
  martingms = {
    email = "martin@mg.am";
    github = "martingms";
    githubId = 458783;
    name = "Martin Gammelsæter";
  };
  martfont = {
    name = "Martino Fontana";
    email = "tinozzo123@tutanota.com";
    github = "SuperSamus";
    githubId = 40663462;
  };
  marzipankaiser = {
    email = "nixos@gaisseml.de";
    github = "marzipankaiser";
    githubId = 2551444;
    name = "Marcial Gaißert";
    keys = [{
      longkeyid = "rsa2048/0xB629036BE399EEE9";
      fingerprint = "B573 5118 0375 A872 FBBF  7770 B629 036B E399 EEE9";
    }];
  };
  masipcat = {
    email = "jordi@masip.cat";
    github = "masipcat";
    githubId = 775189;
    name = "Jordi Masip";
  };
  MaskedBelgian = {
    email = "michael.colicchia@imio.be";
    github = "MaskedBelgian";
    githubId = 29855073;
    name = "Michael Colicchia";
  };
  matejc = {
    email = "cotman.matej@gmail.com";
    github = "matejc";
    githubId = 854770;
    name = "Matej Cotman";
  };
  mathnerd314 = {
    email = "mathnerd314.gph+hs@gmail.com";
    github = "mathnerd314";
    githubId = 322214;
    name = "Mathnerd314";
  };
  matklad = {
    email = "aleksey.kladov@gmail.com";
    github = "matklad";
    githubId = 1711539;
    name = "matklad";
  };
  matt-snider = {
    email = "matt.snider@protonmail.com";
    github = "matt-snider";
    githubId = 11810057;
    name = "Matt Snider";
  };
  mattchrist = {
    email = "nixpkgs-matt@christ.systems";
    github = "mattchrist";
    githubId = 952712;
    name = "Matt Christ";
  };
  matthewbauer = {
    email = "mjbauer95@gmail.com";
    github = "matthewbauer";
    githubId = 19036;
    name = "Matthew Bauer";
  };
  matthiasbeyer = {
    email = "mail@beyermatthias.de";
    matrix = "@musicmatze:beyermatthi.as";
    github = "matthiasbeyer";
    githubId = 427866;
    name = "Matthias Beyer";
  };
  matthuszagh = {
    email = "huszaghmatt@gmail.com";
    github = "matthuszagh";
    githubId = 7377393;
    name = "Matt Huszagh";
  };
  matti-kariluoma = {
    email = "matti@kariluo.ma";
    github = "matti-kariluoma";
    githubId = 279868;
    name = "Matti Kariluoma";
  };
  maurer = {
    email = "matthew.r.maurer+nix@gmail.com";
    github = "maurer";
    githubId = 136037;
    name = "Matthew Maurer";
  };
  mausch = {
    email = "mauricioscheffer@gmail.com";
    github = "mausch";
    githubId = 95194;
    name = "Mauricio Scheffer";
  };
  max-niederman = {
    email = "max@maxniederman.com";
    github = "max-niederman";
    githubId = 19580458;
    name = "Max Niederman";
    keys = [{
      longkeyid = "rsa3072/0x9AED881481D8444E";
      fingerprint = "1DE4 424D BF77 1192 5DC4  CF5E 9AED 8814 81D8 444E";
    }];
  };
  maxdamantus = {
    email = "maxdamantus@gmail.com";
    github = "Maxdamantus";
    githubId = 502805;
    name = "Max Zerzouri";
  };
  maxeaubrey = {
    email = "maxeaubrey@gmail.com";
    github = "maxeaubrey";
    githubId = 35892750;
    name = "Maxine Aubrey";
  };
  maxhille = {
    email = "mh@lambdasoup.com";
    github = "maxhille";
    githubId = 693447;
    name = "Max Hille";
  };
  maxhbr = {
    email = "nixos@maxhbr.dev";
    github = "maxhbr";
    githubId = 1187050;
    name = "Maximilian Huber";
  };
  maxxk = {
    email = "maxim.krivchikov@gmail.com";
    github = "maxxk";
    githubId = 1191859;
    name = "Maxim Krivchikov";
  };
  MayNiklas = {
    email = "info@niklas-steffen.de";
    github = "MayNiklas";
    githubId = 44636701;
    name = "Niklas Steffen";
  };
  mazurel = {
    email = "mateusz.mazur@yahoo.com";
    github = "Mazurel";
    githubId = 22836301;
    name = "Mateusz Mazur";
  };
  mbaeten = {
    email = "mbaeten@users.noreply.github.com";
    github = "mbaeten";
    githubId = 2649304;
    name = "M. Baeten";
  };
  mbaillie = {
    email = "martin@baillie.id";
    github = "martinbaillie";
    githubId = 613740;
    name = "Martin Baillie";
  };
  mbbx6spp = {
    email = "me@susanpotter.net";
    github = "mbbx6spp";
    githubId = 564;
    name = "Susan Potter";
  };
  mbe = {
    email = "brandonedens@gmail.com";
    github = "brandonedens";
    githubId = 396449;
    name = "Brandon Edens";
  };
  mbode = {
    email = "maxbode@gmail.com";
    github = "mbode";
    githubId = 9051309;
    name = "Maximilian Bode";
  };
  mboes = {
    email = "mboes@tweag.net";
    github = "mboes";
    githubId = 51356;
    name = "Mathieu Boespflug";
  };
  mbprtpmnr = {
    name = "mbprtpmnr";
    email = "mbprtpmnr@pm.me";
    github = "mbprtpmnr";
    githubId = 88109321;
  };
  mbrgm = {
    email = "marius@yeai.de";
    github = "mbrgm";
    githubId = 2971615;
    name = "Marius Bergmann";
  };
  mcaju = {
    email = "cajum.bugs@yandex.com";
    github = "CajuM";
    githubId = 10420834;
    name = "Mihai-Drosi Caju";
  };
  mcbeth = {
    email = "mcbeth@broggs.org";
    github = "mcbeth";
    githubId = 683809;
    name = "Jeffrey Brent McBeth";
  };
  mcmtroffaes = {
    email = "matthias.troffaes@gmail.com";
    github = "mcmtroffaes";
    githubId = 158568;
    name = "Matthias C. M. Troffaes";
  };
  McSinyx = {
    email = "mcsinyx@disroot.org";
    github = "McSinyx";
    githubId = 13689192;
    name = "Nguyễn Gia Phong";
    keys = [{
      longkeyid = "rsa3072/0x27148B2C06A2224B";
      fingerprint = "E90E 11B8 0493 343B 6132  E394 2714 8B2C 06A2 224B";
    }];
  };
  mcwitt = {
    email = "mcwitt@gmail.com";
    github = "mcwitt";
    githubId = 319411;
    name = "Matt Wittmann";
  };
  mdaiter = {
    email = "mdaiter8121@gmail.com";
    github = "mdaiter";
    githubId = 1377571;
    name = "Matthew S. Daiter";
  };
  mdevlamynck = {
    email = "matthias.devlamynck@mailoo.org";
    github = "mdevlamynck";
    githubId = 4378377;
    name = "Matthias Devlamynck";
  };
  mdlayher = {
    email = "mdlayher@gmail.com";
    github = "mdlayher";
    githubId = 1926905;
    name = "Matt Layher";
    keys = [{
      longkeyid = "rsa2048/0x77BFE531397EDE94";
      fingerprint = "D709 03C8 0BE9 ACDC 14F0  3BFB 77BF E531 397E DE94";
    }];
  };
  meatcar = {
    email = "nixpkgs@denys.me";
    github = "meatcar";
    githubId = 191622;
    name = "Denys Pavlov";
  };
  meditans = {
    email = "meditans@gmail.com";
    github = "meditans";
    githubId = 4641445;
    name = "Carlo Nucera";
  };
  megheaiulian = {
    email = "iulian.meghea@gmail.com";
    github = "megheaiulian";
    githubId = 1788114;
    name = "Meghea Iulian";
  };
  mehandes = {
    email = "niewskici@gmail.com";
    github = "mehandes";
    githubId = 32581276;
    name = "Matt Deming";
  };
  meisternu = {
    email = "meister@krutt.org";
    github = "meisternu";
    githubId = 8263431;
    name = "Matt Miemiec";
  };
  melchips = {
    email = "truphemus.francois@gmail.com";
    github = "melchips";
    githubId = 365721;
    name = "Francois Truphemus";
  };
  melsigl = {
    email = "melanie.bianca.sigl@gmail.com";
    github = "melsigl";
    githubId = 15093162;
    name = "Melanie B. Sigl";
  };
  melkor333 = {
    email = "samuel@ton-kunst.ch";
    github = "melkor333";
    githubId = 6412377;
    name = "Samuel Ruprecht";
  };
  metabar = {
    email = "softs@metabarcoding.org";
    name = "Celine Mercier";
  };
  kira-bruneau = {
    email = "kira.bruneau@pm.me";
    name = "Kira Bruneau";
    github = "kira-bruneau";
    githubId = 382041;
  };
  meutraa = {
    email = "paul+nixpkgs@lost.host";
    name = "Paul Meredith";
    github = "meutraa";
    githubId = 68550871;
  };
  mephistophiles = {
    email = "mussitantesmortem@gmail.com";
    name = "Maxim Zhukov";
    github = "Mephistophiles";
    githubId = 4850908;
  };
  mfossen = {
    email = "msfossen@gmail.com";
    github = "mfossen";
    githubId = 3300322;
    name = "Mitchell Fossen";
  };
  mgdelacroix = {
    email = "mgdelacroix@gmail.com";
    github = "mgdelacroix";
    githubId = 223323;
    name = "Miguel de la Cruz";
  };
  mgdm = {
    email = "michael@mgdm.net";
    github = "mgdm";
    githubId = 71893;
    name = "Michael Maclean";
  };
  mgregoire = {
    email = "gregoire@martinache.net";
    github = "M-Gregoire";
    githubId = 9469313;
    name = "Gregoire Martinache";
  };
  mgttlinger = {
    email = "megoettlinger@gmail.com";
    github = "mgttlinger";
    githubId = 5120487;
    name = "Merlin Göttlinger";
  };
  mguentner = {
    email = "code@klandest.in";
    github = "mguentner";
    githubId = 668926;
    name = "Maximilian Güntner";
  };
  mhaselsteiner = {
    email = "magdalena.haselsteiner@gmx.at";
    github = "mhaselsteiner";
    githubId = 20536514;
    name = "Magdalena Haselsteiner";
  };
  mic92 = {
    email = "joerg@thalheim.io";
    matrix = "@mic92:nixos.dev";
    github = "mic92";
    githubId = 96200;
    name = "Jörg Thalheim";
    keys = [{
      # compare with https://keybase.io/Mic92
      longkeyid = "rsa4096/0x003F2096411B5F92";
      fingerprint = "3DEE 1C55 6E1C 3DC5 54F5  875A 003F 2096 411B 5F92";
    }];
  };
  michaeladler = {
    email = "therisen06@gmail.com";
    github = "michaeladler";
    githubId = 1575834;
    name = "Michael Adler";
  };
  michaelpj = {
    email = "michaelpj@gmail.com";
    github = "michaelpj";
    githubId = 1699466;
    name = "Michael Peyton Jones";
  };
  michalrus = {
    email = "m@michalrus.com";
    github = "michalrus";
    githubId = 4366292;
    name = "Michal Rus";
  };
  michelk = {
    email = "michel@kuhlmanns.info";
    github = "michelk";
    githubId = 1404919;
    name = "Michel Kuhlmann";
  };
  michojel = {
    email = "mic.liamg@gmail.com";
    github = "michojel";
    githubId = 21156022;
    name = "Michal Minář";
  };
  michzappa = {
    email = "me@michzappa.com";
    github = "michzappa";
    githubId = 59343378;
    name = "Michael Zappa";
  };
  mickours = {
    email = "mickours@gmail.com<";
    github = "mickours";
    githubId = 837312;
    name = "Michael Mercier";
  };
  midchildan = {
    email = "git@midchildan.org";
    matrix = "@midchildan:matrix.org";
    github = "midchildan";
    githubId = 7343721;
    name = "midchildan";
    keys = [{
      longkeyid = "rsa4096/0x186A1EDAC5C63F83";
      fingerprint = "FEF0 AE2D 5449 3482 5F06  40AA 186A 1EDA C5C6 3F83";
    }];
  };
  mikefaille = {
    email = "michael@faille.io";
    github = "mikefaille";
    githubId = 978196;
    name = "Michaël Faille";
  };
  mikoim = {
    email = "ek@esh.ink";
    github = "mikoim";
    githubId = 3958340;
    name = "Eshin Kunishima";
  };
  mikesperber = {
    email = "sperber@deinprogramm.de";
    github = "mikesperber";
    githubId = 1387206;
    name = "Mike Sperber";
  };
  mikroskeem = {
    email = "mikroskeem@mikroskeem.eu";
    github = "mikroskeem";
    githubId = 3490861;
    name = "Mark Vainomaa";
    keys = [{
      longkeyid = "rsa4096/0xDA015B05B5A11B22";
      fingerprint = "DB43 2895 CF68 F0CE D4B7  EF60 DA01 5B05 B5A1 1B22";
    }];
  };
  milahu = {
    email = "milahu@gmail.com";
    github = "milahu";
    githubId = 12958815;
    name = "Milan Hauth";
  };
  milesbreslin = {
    email = "milesbreslin@gmail.com";
    github = "milesbreslin";
    githubId = 38543128;
    name = "Miles Breslin";
  };
  milibopp = {
    email = "contact@ebopp.de";
    github = "milibopp";
    githubId = 3098430;
    name = "Emilia Bopp";
  };
  millerjason = {
    email = "mailings-github@millerjason.com";
    github = "millerjason";
    githubId = 7610974;
    name = "Jason Miller";
  };
  milogert = {
    email = "milo@milogert.com";
    github = "milogert";
    githubId = 5378535;
    name = "Milo Gertjejansen";
  };
  miltador = {
    email = "miltador@yandex.ua";
    name = "Vasiliy Solovey";
  };
  mimame = {
    email = "miguel.madrid.mencia@gmail.com";
    github = "mimame";
    githubId = 3269878;
    name = "Miguel Madrid Mencía";
  };
  mindavi = {
    email = "rol3517@gmail.com";
    github = "Mindavi";
    githubId = 9799623;
    name = "Rick van Schijndel";
  };
  minijackson = {
    email = "minijackson@riseup.net";
    github = "minijackson";
    githubId = 1200507;
    name = "Rémi Nicole";
    keys = [{
      longkeyid = "rsa2048/0xFEA888C9F5D64F62";
      fingerprint = "3196 83D3 9A1B 4DE1 3DC2  51FD FEA8 88C9 F5D6 4F62";
    }];
  };
  mir06 = {
    email = "armin.leuprecht@uni-graz.at";
    github = "mir06";
    githubId = 8479244;
    name = "Armin Leuprecht";
  };
  mirdhyn = {
    email = "mirdhyn@gmail.com";
    github = "mirdhyn";
    githubId = 149558;
    name = "Merlin Gaillard";
  };
  mirrexagon = {
    email = "mirrexagon@mirrexagon.com";
    github = "mirrexagon";
    githubId = 1776903;
    name = "Andrew Abbott";
  };
  mitchmindtree = {
    email = "mail@mitchellnordine.com";
    github = "mitchmindtree";
    githubId = 4587373;
    name = "Mitchell Nordine";
  };
  mjanczyk = {
    email = "m@dragonvr.pl";
    github = "mjanczyk";
    githubId = 1001112;
    name = "Marcin Janczyk";
  };
  mjlbach = {
    email = "m.j.lbach@gmail.com";
    matrix = "@atrius:matrix.org";
    github = "mjlbach";
    githubId = 13316262;
    name = "Michael Lingelbach";
  };
  mjp = {
    email = "mike@mythik.co.uk";
    github = "MikePlayle";
    githubId = 16974598;
    name = "Mike Playle";
  };
  mkaito = {
    email = "chris@mkaito.net";
    github = "mkaito";
    githubId = 20434;
    name = "Christian Höppner";
  };
  mkazulak = {
    email = "kazulakm@gmail.com";
    github = "mulderr";
    githubId = 5698461;
    name = "Maciej Kazulak";
  };
  mkf = {
    email = "m@mikf.pl";
    github = "mkf";
    githubId = 7753506;
    name = "Michał Krzysztof Feiler";
    keys = [{
      longkeyid = "rsa4096/0xE35C2D7C2C6AC724";
      fingerprint = "1E36 9940 CC7E 01C4 CFE8  F20A E35C 2D7C 2C6A C724";
    }];
  };
  mkg = {
    email = "mkg@vt.edu";
    github = "mkgvt";
    githubId = 22477669;
    name = "Mark K Gardner";
  };
  mkg20001 = {
    email = "mkg20001+nix@gmail.com";
    matrix = "@mkg20001:matrix.org";
    github = "mkg20001";
    githubId = 7735145;
    name = "Maciej Krüger";
    keys = [{
      longkeyid = "rsa4096/0x0D948CE19CF49C5F";
      fingerprint = "E90C BA34 55B3 6236 740C  038F 0D94 8CE1 9CF4 9C5F";
    }];
  };
  mlieberman85 = {
    email = "mlieberman85@gmail.com";
    github = "mlieberman85";
    githubId = 622577;
    name = "Michael Lieberman";
  };
  mlvzk = {
    name = "mlvzk";
    email = "mlvzk@users.noreply.github.com";
    github = "mlvzk";
    githubId = 44906333;
  };
  mmahut = {
    email = "marek.mahut@gmail.com";
    github = "mmahut";
    githubId = 104795;
    name = "Marek Mahut";
  };
  mmai = {
    email = "henri.bourcereau@gmail.com";
    github = "mmai";
    githubId = 117842;
    name = "Henri Bourcereau";
  };
  mmesch = {
    email = "mmesch@noreply.github.com";
    github = "mmesch";
    githubId = 2597803;
    name = "Matthias Meschede";
  };
  mmilata = {
    email = "martin@martinmilata.cz";
    github = "mmilata";
    githubId = 85857;
    name = "Martin Milata";
  };
  mmlb = {
    email = "manny@peekaboo.mmlb.icu";
    github = "mmlb";
    githubId = 708570;
    name = "Manuel Mendez";
  };
  mnacamura = {
    email = "m.nacamura@gmail.com";
    github = "mnacamura";
    githubId = 45770;
    name = "Mitsuhiro Nakamura";
  };
  moaxcp = {
    email = "moaxcp@gmail.com";
    github = "moaxcp";
    githubId = 7831184;
    name = "John Mercier";
  };
  modulistic = {
    email = "modulistic@gmail.com";
    github = "modulistic";
    githubId = 1902456;
    name = "Pablo Costa";
  };
  mog = {
    email = "mog-lists@rldn.net";
    github = "mogorman";
    githubId = 64710;
    name = "Matthew O'Gorman";
  };
  Mogria = {
    email = "m0gr14@gmail.com";
    github = "mogria";
    githubId = 754512;
    name = "Mogria";
  };
  mohe2015 = {
    name = "Moritz Hedtke";
    email = "Moritz.Hedtke@t-online.de";
    matrix = "@moritz.hedtke:matrix.org";
    github = "mohe2015";
    githubId = 13287984;
    keys = [{
      longkeyid = "rsa4096/0x6794D45A488C2EDE";
      fingerprint = "1248 D3E1 1D11 4A85 75C9  8934 6794 D45A 488C 2EDE";
    }];
  };
  monsieurp = {
    email = "monsieurp@gentoo.org";
    github = "monsieurp";
    githubId = 350116;
    name = "Patrice Clement";
  };
  montag451 = {
    email = "montag451@laposte.net";
    github = "montag451";
    githubId = 249317;
    name = "montag451";
  };
  moosingin3space = {
    email = "moosingin3space@gmail.com";
    github = "moosingin3space";
    githubId = 830082;
    name = "Nathan Moos";
  };
  moredread = {
    email = "code@apb.name";
    github = "moredread";
    githubId = 100848;
    name = "André-Patrick Bubel";
    keys = [{
      longkeyid = "rsa8192/0x118CE7C424B45728";
      fingerprint = "4412 38AD CAD3 228D 876C  5455 118C E7C4 24B4 5728";
    }];
  };
  moretea = {
    email = "maarten@moretea.nl";
    github = "moretea";
    githubId = 99988;
    name = "Maarten Hoogendoorn";
  };
  MoritzBoehme = {
    email = "mail@moritzboeh.me";
    github = "MoritzBoehme";
    githubId = 42215704;
    name = "Moritz Böhme";
  };
  MostAwesomeDude = {
    email = "cds@corbinsimpson.com";
    github = "MostAwesomeDude";
    githubId = 118035;
    name = "Corbin Simpson";
  };
  mothsart = {
    email = "jerem.ferry@gmail.com";
    github = "mothsart";
    githubId = 10601196;
    name = "Jérémie Ferry";
  };
  mounium = {
    email = "muoniurn@gmail.com";
    github = "mounium";
    githubId = 20026143;
    name = "Katona László";
  };
  MP2E = {
    email = "MP2E@archlinux.us";
    github = "MP2E";
    githubId = 167708;
    name = "Cray Elliott";
  };
  mpcsh = {
    email = "m@mpc.sh";
    github = "mpcsh";
    githubId = 2894019;
    name = "Mark Cohen";
  };
  mpickering = {
    email = "matthewtpickering@gmail.com";
    github = "mpickering";
    githubId = 1216657;
    name = "Matthew Pickering";
  };
  mpoquet = {
    email = "millian.poquet@gmail.com";
    github = "mpoquet";
    githubId = 3502831;
    name = "Millian Poquet";
  };
  mpscholten = {
    email = "marc@mpscholten.de";
    github = "mpscholten";
    githubId = 2072185;
    name = "Marc Scholten";
  };
  mpsyco = {
    email = "fr.st-amour@gmail.com";
    github = "fstamour";
    githubId = 2881922;
    name = "Francis St-Amour";
  };
  mtrsk = {
    email = "marcos.schonfinkel@protonmail.com";
    github = "mtrsk";
    githubId = 16356569;
    name = "Marcos Benevides";
  };
  mredaelli = {
    email = "massimo@typish.io";
    github = "mredaelli";
    githubId = 3073833;
    name = "Massimo Redaelli";
  };
  mrkkrp = {
    email = "markkarpov92@gmail.com";
    github = "mrkkrp";
    githubId = 8165792;
    name = "Mark Karpov";
  };
  mrmebelman = {
    email = "burzakovskij@protonmail.com";
    github = "MrMebelMan";
    githubId = 15896005;
    name = "Vladyslav Burzakovskyy";
  };
  mrVanDalo = {
    email = "contact@ingolf-wagner.de";
    github = "mrVanDalo";
    githubId = 839693;
    name = "Ingolf Wanger";
  };
  msackman = {
    email = "matthew@wellquite.org";
    name = "Matthew Sackman";
  };
  mschneider = {
    email = "markus.schneider.sic+nix@gmail.com";
    name = "Markus Schneider";
  };
  mschristiansen = {
    email = "mikkel@rheosystems.com";
    github = "mschristiansen";
    githubId = 437005;
    name = "Mikkel Christiansen";
  };
  mschuwalow = {
    github = "mschuwalow";
    githubId = 16665913;
    name = "Maxim Schuwalow";
    email = "maxim.schuwalow@gmail.com";
  };
  msfjarvis = {
    github = "msfjarvis";
    githubId = 3348378;
    name = "Harsh Shandilya";
    email = "nixos@msfjarvis.dev";
    keys = [{
      longkeyid = "rsa4096/0xB7843F823355E9B9";
      fingerprint = "8F87 050B 0F9C B841 1515  7399 B784 3F82 3355 E9B9";
    }];
  };
  msiedlarek = {
    email = "mikolaj@siedlarek.pl";
    github = "msiedlarek";
    githubId = 133448;
    name = "Mikołaj Siedlarek";
  };
  msm = {
    email = "msm@tailcall.net";
    github = "msm-code";
    githubId = 7026881;
    name = "Jarosław Jedynak";
  };
  mstarzyk = {
    email = "mstarzyk@gmail.com";
    github = "mstarzyk";
    githubId = 111304;
    name = "Maciek Starzyk";
  };
  msteen = {
    email = "emailmatthijs@gmail.com";
    github = "msteen";
    githubId = 788953;
    name = "Matthijs Steen";
  };
  mstrangfeld = {
    email = "marvin@strangfeld.io";
    github = "mstrangfeld";
    githubId = 36842980;
    name = "Marvin Strangfeld";
  };
  mt-caret = {
    email = "mtakeda.enigsol@gmail.com";
    github = "mt-caret";
    githubId = 4996739;
    name = "Masayuki Takeda";
  };
  mtesseract = {
    email = "moritz@stackrox.com";
    github = "mtesseract";
    githubId = 11706080;
    name = "Moritz Clasmeier";
  };
  MtP = {
    email = "marko.nixos@poikonen.de";
    github = "MtP76";
    githubId = 2176611;
    name = "Marko Poikonen";
  };
  mtreca = {
    email = "maxime.treca@gmail.com";
    github = "mtreca";
    githubId = 16440823;
    name = "Maxime Tréca";
  };
  mtreskin = {
    email = "zerthurd@gmail.com";
    github = "Zert";
    githubId = 39034;
    name = "Max Treskin";
  };
  mudri = {
    email = "lamudri@gmail.com";
    github = "laMudri";
    githubId = 5139265;
    name = "James Wood";
  };
  mudrii = {
    email = "mudreac@gmail.com";
    github = "mudrii";
    githubId = 220262;
    name = "Ion Mudreac";
  };
  muflax = {
    email = "mail@muflax.com";
    github = "muflax";
    githubId = 69918;
    name = "Stefan Dorn";
  };
  multun = {
    email = "victor.collod@epita.fr";
    github = "multun";
    githubId = 5047140;
    name = "Victor Collod";
  };
  musfay = {
    email = "musfay@protonmail.com";
    github = "musfay";
    githubId = 33374965;
    name = "Mustafa Çalışkan";
  };
  mupdt = {
    email = "nix@pdtpartners.com";
    github = "mupdt";
    githubId = 25388474;
    name = "Matej Urbas";
  };
  mvnetbiz = {
    email = "mvnetbiz@gmail.com";
    matrix = "@mvtva:matrix.org";
    github = "mvnetbiz";
    githubId = 6455574;
    name = "Matt Votava";
  };
  mvs = {
    email = "mvs@nya.yt";
    github = "illdefined";
    githubId = 772914;
    name = "Mikael Voss";
  };
  maxwilson = {
    email = "nixpkgs@maxwilson.dev";
    github = "mwilsoncoding";
    githubId = 43796009;
    name = "Max Wilson";
  };
  myrl = {
    email = "myrl.0xf@gmail.com";
    github = "myrl";
    githubId = 9636071;
    name = "Myrl Hex";
  };
  nadrieril = {
    email = "nadrieril@gmail.com";
    github = "nadrieril";
    githubId = 6783654;
    name = "Nadrieril Feneanar";
  };
  nalbyuites = {
    email = "ashijit007@gmail.com";
    github = "nalbyuites";
    githubId = 1009523;
    name = "Ashijit Pramanik";
  };
  namore = {
    email = "namor@hemio.de";
    github = "namore";
    githubId = 1222539;
    name = "Roman Naumann";
  };
  nasirhm = {
    email = "nasirhussainm14@gmail.com";
    github = "nasirhm";
    githubId = 35005234;
    name = "Nasir Hussain";
    keys = [{
      longkeyid = "rsa4096/0xD8126E559CE7C35D";
      fingerprint = "7A10 AB8E 0BEC 566B 090C  9BE3 D812 6E55 9CE7 C35D";
    }];
  };
  Nate-Devv = {
    email = "natedevv@gmail.com";
    name = "Nathan Moore";
  };
  nathanruiz = {
    email = "nathanruiz@protonmail.com";
    github = "nathanruiz";
    githubId = 18604892;
    name = "Nathan Ruiz";
  };
  nathan-gs = {
    email = "nathan@nathan.gs";
    github = "nathan-gs";
    githubId = 330943;
    name = "Nathan Bijnens";
  };
  nathyong = {
    email = "nathyong@noreply.github.com";
    github = "nathyong";
    githubId = 818502;
    name = "Nathan Yong";
  };
  natto1784 = {
    email = "natto@weirdnatto.in";
    github = "natto1784";
    githubId = 56316606;
    name = "Amneesh Singh";
  };
  nazarewk = {
    name = "Krzysztof Nazarewski";
    email = "3494992+nazarewk@users.noreply.github.com";
    matrix = "@nazarewk:matrix.org";
    github = "nazarewk";
    githubId = 3494992;
    keys = [{
      longkeyid = "rsa4096/0x916D8B67241892AE";
      fingerprint = "4BFF 0614 03A2 47F0 AA0B 4BC4 916D 8B67 2418 92AE";
    }];
  };
  nbren12 = {
    email = "nbren12@gmail.com";
    github = "nbren12";
    githubId = 1386642;
    name = "Noah Brenowitz";
  };
  ncfavier = {
    email = "n@monade.li";
    matrix = "@ncfavier:matrix.org";
    github = "ncfavier";
    githubId = 4323933;
    name = "Naïm Favier";
    keys = [{
      longkeyid = "rsa2048/0x49B07322580B7EE2";
      fingerprint = "51A0 705E 7DD2 3CBC 5EAA  B43E 49B0 7322 580B 7EE2";
    }];
  };
  nckx = {
    email = "github@tobias.gr";
    github = "nckx";
    githubId = 364510;
    name = "Tobias Geerinckx-Rice";
  };
  ndl = {
    email = "ndl@endl.ch";
    github = "ndl";
    githubId = 137805;
    name = "Alexander Tsvyashchenko";
  };
  neeasade = {
    email = "nathanisom27@gmail.com";
    github = "neeasade";
    githubId = 3747396;
    name = "Nathan Isom";
  };
  nelsonjeppesen = {
    email = "nix@jeppesen.io";
    github = "NelsonJeppesen";
    githubId = 50854675;
    name = "Nelson Jeppesen";
  };
  neonfuz = {
    email = "neonfuz@gmail.com";
    github = "neonfuz";
    githubId = 2590830;
    name = "Sage Raflik";
  };
  neosimsim = {
    email = "me@abn.sh";
    github = "neosimsim";
    githubId = 1771772;
    name = "Alexander Ben Nasrallah";
  };
  nequissimus = {
    email = "tim@nequissimus.com";
    github = "nequissimus";
    githubId = 628342;
    name = "Tim Steinbach";
  };
  nerdypepper = {
    email = "nerdy@peppe.rs";
    github = "nerdypepper";
    githubId = 23743547;
    name = "Akshay Oppiliappan";
  };
  nessdoor = {
    name = "Tomas Antonio Lopez";
    email = "entropy.overseer@protonmail.com";
    githubId = 25993494;
  };
  netcrns = {
    email = "jason.wing@gmx.de";
    github = "netcrns";
    githubId = 34162313;
    name = "Jason Wing";
  };
  netixx = {
    email = "dev.espinetfrancois@gmail.com";
    github = "netixx";
    githubId = 1488603;
    name = "François Espinet";
  };
  neverbehave = {
    email = "i@never.pet";
    github = "NeverBehave";
    githubId = 17120571;
    name = "Xinhao Luo";
  };
  newam = {
    email = "alex@thinglab.org";
    github = "newAM";
    githubId = 7845120;
    name = "Alex Martens";
  };
  nialov = {
    email = "nikolasovaskainen@gmail.com";
    github = "nialov";
    githubId = 47318483;
    name = "Nikolas Ovaskainen";
  };
  nikitavoloboev = {
    email = "nikita.voloboev@gmail.com";
    github = "nikitavoloboev";
    githubId = 6391776;
    name = "Nikita Voloboev";
  };
  nfjinjing = {
    email = "nfjinjing@gmail.com";
    name = "Jinjing Wang";
  };
  nh2 = {
    email = "mail@nh2.me";
    matrix = "@nh2:matrix.org";
    github = "nh2";
    githubId = 399535;
    name = "Niklas Hambüchen";
  };
  nhooyr = {
    email = "anmol@aubble.com";
    github = "nhooyr";
    githubId = 10180857;
    name = "Anmol Sethi";
  };
  nicbk = {
    email = "nicolas@nicbk.com";
    github = "nicbk";
    githubId = 77309427;
    name = "Nicolás Kennedy";
    keys = [{
      longkeyid = "rsa4096/0xC061089EFEBF7A35";
      fingerprint = "7BC1 77D9 C222 B1DC FB2F  0484 C061 089E FEBF 7A35";
    }];
  };
  nichtsfrei = {
    email = "philipp.eder@posteo.net";
    github = "nichtsfrei";
    githubId = 1665818;
    name = "Philipp Eder";
  };
  nickcao = {
    name = "Nick Cao";
    email = "nickcao@nichi.co";
    github = "NickCao";
    githubId = 15247171;
  };
  nickhu = {
    email = "me@nickhu.co.uk";
    github = "nickhu";
    githubId = 450276;
    name = "Nick Hu";
  };
  nicknovitski = {
    email = "nixpkgs@nicknovitski.com";
    github = "nicknovitski";
    githubId = 151337;
    name = "Nick Novitski";
  };
  nico202 = {
    email = "anothersms@gmail.com";
    github = "nico202";
    githubId = 8214542;
    name = "Nicolò Balzarotti";
  };
  NieDzejkob = {
    email = "kuba@kadziolka.net";
    github = "NieDzejkob";
    githubId = 23580910;
    name = "Jakub Kądziołka";
    keys = [{
      longkeyid = "rsa4096/0xE315A75846131564";
      fingerprint = "E576 BFB2 CF6E B13D F571  33B9 E315 A758 4613 1564";
    }];
  };
  NikolaMandic = {
    email = "nikola@mandic.email";
    github = "NikolaMandic";
    githubId = 4368690;
    name = "Ratko Mladic";
  };
  nilp0inter = {
    email = "robertomartinezp@gmail.com";
    github = "nilp0inter";
    githubId = 1224006;
    name = "Roberto Abdelkader Martínez Pérez";
  };
  nilsirl = {
    email = "nils@nilsand.re";
    github = "NilsIrl";
    githubId = 26231126;
    name = "Nils ANDRÉ-CHANG";
  };
  nils-degroot = {
    email = "nils@peeko.nl";
    github = "nils-degroot";
    githubId = 53556985;
    name = "Nils de Groot";
  };
  ninjatrappeur = {
    email = "felix@alternativebit.fr";
    matrix = "@ninjatrappeur:matrix.org";
    github = "ninjatrappeur";
    githubId = 1219785;
    name = "Félix Baylac-Jacqué";
  };
  ninjin = {
    email = "pontus@stenetorp.se";
    github = "ninjin";
    githubId = 354934;
    name = "Pontus Stenetorp";
    keys = [{
      longkeyid = "rsa4096/0xD430287500E6483C";
      fingerprint = "0966 2F9F 3FDA C22B C22E  4CE1 D430 2875 00E6 483C";
    }];
  };
  nioncode = {
    email = "nioncode+github@gmail.com";
    github = "nioncode";
    githubId = 3159451;
    name = "Nicolas Schneider";
  };
  nkje = {
    name = "Niels Kristian Lyshøj Jensen";
    email = "n@nk.je";
    github = "NKJe";
    githubId = 1102306;
    keys = [{
      longkeyid = "nistp256/0xDE3BADFECD31A89D";
      fingerprint = "B956 C6A4 22AF 86A0 8F77  A8CA DE3B ADFE CD31 A89D";
    }];
  };
  nitsky = {
    name = "nitsky";
    email = "492793+nitsky@users.noreply.github.com";
    github = "nitsky";
    githubId = 492793;
  };
  nkpvk = {
    email = "niko.pavlinek@gmail.com";
    github = "nkpvk";
    githubId = 16385648;
    name = "Niko Pavlinek";
  };
  nixbitcoin = {
    email = "nixbitcoin@i2pmail.org";
    github = "nixbitcoin";
    githubId = 45737139;
    name = "nixbitcoindev";
    keys = [{
      longkeyid = "rsa4096/0xDD11F9AD5308B3BA";
      fingerprint = "577A 3452 7F3E 2A85 E80F  E164 DD11 F9AD 5308 B3BA";
    }];
  };
  nixinator = {
    email = "33lockdown33@protonmail.com";
    matrix = "@nixinator:nixos.dev";
    github = "nixinator";
    githubId = 66913205;
    name = "Rick Sanchez";
  };
  nixy = {
    email = "nixy@nixy.moe";
    github = "nixy";
    githubId = 7588406;
    name = "Andrew R. M.";
  };
  nkalupahana = {
    email = "hello@nisa.la";
    github = "nkalupahana";
    githubId = 7347290;
    name = "Nisala Kalupahana";
  };
  nloomans = {
    email = "noah@nixos.noahloomans.com";
    github = "nloomans";
    githubId = 7829481;
    name = "Noah Loomans";
  };
  nmattia = {
    email = "nicolas@nmattia.com";
    github = "nmattia";
    githubId = 6930756;
    name = "Nicolas Mattia";
  };
  nobbz = {
    name = "Norbert Melzer";
    email = "timmelzer+nixpkgs@gmail.com";
    github = "NobbZ";
    githubId = 58951;
  };
  nocoolnametom = {
    email = "nocoolnametom@gmail.com";
    github = "nocoolnametom";
    githubId = 810877;
    name = "Tom Doggett";
  };
  noisersup = {
    email = "patryk@kwiatek.xyz";
    github = "noisersup";
    githubId = 42322511;
    name = "Patryk Kwiatek";
  };
  nomeata = {
    email = "mail@joachim-breitner.de";
    github = "nomeata";
    githubId = 148037;
    name = "Joachim Breitner";
  };
  nomisiv = {
    email = "simon@nomisiv.com";
    github = "NomisIV";
    githubId = 47303199;
    name = "Simon Gutgesell";
  };
  noneucat = {
    email = "andy@lolc.at";
    matrix = "@noneucat:lolc.at";
    github = "noneucat";
    githubId = 40049608;
    name = "Andy Chun";
  };
  noreferences = {
    email = "norkus@norkus.net";
    github = "jozuas";
    githubId = 13085275;
    name = "Juozas Norkus";
  };
  norfair = {
    email = "syd@cs-syd.eu";
    github = "NorfairKing";
    githubId = 3521180;
    name = "Tom Sydney Kerckhove";
  };
  notthemessiah = {
    email = "brian.cohen.88@gmail.com";
    github = "notthemessiah";
    githubId = 2946283;
    name = "Brian Cohen";
  };
  novoxudonoser = {
    email = "radnovox@gmail.com";
    github = "novoxudonoser";
    githubId = 6052922;
    name = "Kirill Struokov";
  };
  np = {
    email = "np.nix@nicolaspouillard.fr";
    github = "np";
    githubId = 5548;
    name = "Nicolas Pouillard";
  };
  nphilou = {
    email = "nphilou@gmail.com";
    github = "nphilou";
    githubId = 9939720;
    name = "Philippe Nguyen";
  };
  nrdxp = {
    email = "tim.deh@pm.me";
    matrix = "@timdeh:matrix.org";
    github = "nrdxp";
    githubId = 34083928;
    name = "Tim DeHerrera";
  };
  nshalman = {
    email = "nahamu@gmail.com";
    github = "nshalman";
    githubId = 20391;
    name = "Nahum Shalman";
  };
  nslqqq = {
    email = "nslqqq@gmail.com";
    name = "Nikita Mikhailov";
  };
  nthorne = {
    email = "notrupertthorne@gmail.com";
    github = "nthorne";
    githubId = 1839979;
    name = "Niklas Thörne";
  };
  nukaduka = {
    email = "ksgokte@gmail.com";
    github = "NukaDuka";
    githubId = 22592293;
    name = "Kartik Gokte";
  };
  nullx76 = {
    email = "nix@xirion.net";
    github = "NULLx76";
    githubId = 1809198;
    name = "Victor Roest";
  };
  numinit = {
    email = "me@numin.it";
    github = "numinit";
    githubId = 369111;
    name = "Morgan Jones";
  };
  numkem = {
    name = "Sebastien Bariteau";
    email = "numkem@numkem.org";
    matrix = "@numkem:matrix.org";
    github = "numkem";
    githubId = 332423;
  };
  nyanloutre = {
    email = "paul@nyanlout.re";
    github = "nyanloutre";
    githubId = 7677321;
    name = "Paul Trehiou";
  };
  nyanotech = {
    name = "nyanotech";
    email = "nyanotechnology@gmail.com";
    github = "nyanotech";
    githubId = 33802077;
  };
  nyarly = {
    email = "nyarly@gmail.com";
    github = "nyarly";
    githubId = 127548;
    name = "Judson Lester";
  };
  nzbr = {
    email = "nixos@nzbr.de";
    github = "nzbr";
    githubId = 7851175;
    name = "nzbr";
    matrix = "@nzbr:nzbr.de";
    keys = [{
      longkeyid = "rsa2048/0x6C78B50B97A42F8A";
      fingerprint = "BF3A 3EE6 3144 2C5F C9FB  39A7 6C78 B50B 97A4 2F8A";
    }];
  };
  nzhang-zh = {
    email = "n.zhang.hp.au@gmail.com";
    github = "nzhang-zh";
    githubId = 30825096;
    name = "Ning Zhang";
  };
  obadz = {
    email = "obadz-nixos@obadz.com";
    github = "obadz";
    githubId = 3359345;
    name = "obadz";
  };
  obsidian-systems-maintenance = {
    name = "Obsidian Systems Maintenance";
    email = "maintainer@obsidian.systems";
    github = "obsidian-systems-maintenance";
    githubId = 80847921;
  };
  obfusk = {
    email = "flx@obfusk.net";
    matrix = "@obfusk:matrix.org";
    github = "obfusk";
    githubId = 1260687;
    name = "Felix C. Stegerman";
    keys = [{
      longkeyid = "rsa4096/0x2F9607F09B360F2D";
      fingerprint = "D5E4 A51D F8D2 55B9 FAC6  A9BB 2F96 07F0 9B36 0F2D";
    }];
  };
  odi = {
    email = "oliver.dunkl@gmail.com";
    github = "odi";
    githubId = 158758;
    name = "Oliver Dunkl";
  };
  offline = {
    email = "jaka@x-truder.net";
    github = "offlinehacker";
    githubId = 585547;
    name = "Jaka Hudoklin";
  };
  oida = {
    email = "oida@posteo.de";
    github = "oida";
    githubId = 7249506;
    name = "oida";
  };
  okasu = {
    email = "oka.sux@gmail.com";
    name = "Okasu";
  };
  olcai = {
    email = "dev@timan.info";
    github = "olcai";
    githubId = 20923;
    name = "Erik Timan";
  };
  olebedev = {
    email = "ole6edev@gmail.com";
    github = "olebedev";
    githubId = 848535;
    name = "Oleg Lebedev";
  };
  olejorgenb = {
    email = "olejorgenb@yahoo.no";
    github = "olejorgenb";
    githubId = 72201;
    name = "Ole Jørgen Brønner";
  };
  ollieB = {
    email = "1237862+oliverbunting@users.noreply.github.com";
    github = "oliverbunting";
    githubId = 1237862;
    name = "Ollie Bunting";
  };
  olynch = {
    email = "owen@olynch.me";
    github = "olynch";
    githubId = 4728903;
    name = "Owen Lynch";
  };
  omasanori = {
    email = "167209+omasanori@users.noreply.github.com";
    github = "omasanori";
    githubId = 167209;
    name = "Masanori Ogino";
  };
  omgbebebe = {
    email = "omgbebebe@gmail.com";
    github = "omgbebebe";
    githubId = 588167;
    name = "Sergey Bubnov";
  };
  omnipotententity = {
    email = "omnipotententity@gmail.com";
    github = "omnipotententity";
    githubId = 1538622;
    name = "Michael Reilly";
  };
  onixie = {
    email = "onixie@gmail.com";
    github = "onixie";
    githubId = 817073;
    name = "Yc. Shen";
  };
  onsails = {
    email = "andrey@onsails.com";
    github = "onsails";
    githubId = 107261;
    name = "Andrey Kuznetsov";
  };
  onny = {
    email = "onny@project-insanity.org";
    github = "onny";
    githubId = 757752;
    name = "Jonas Heinrich";
  };
  ony = {
    name = "Mykola Orliuk";
    email = "virkony@gmail.com";
    github = "ony";
    githubId = 11265;
  };
  OPNA2608 = {
    email = "christoph.neidahl@gmail.com";
    github = "OPNA2608";
    githubId = 23431373;
    name = "Christoph Neidahl";
  };
  orbekk = {
    email = "kjetil.orbekk@gmail.com";
    github = "orbekk";
    githubId = 19862;
    name = "KJ Ørbekk";
  };
  orbitz = {
    email = "mmatalka@gmail.com";
    github = "orbitz";
    githubId = 75299;
    name = "Malcolm Matalka";
  };
  orivej = {
    email = "orivej@gmx.fr";
    github = "orivej";
    githubId = 101514;
    name = "Orivej Desh";
  };
  ornxka = {
    email = "ornxka@littledevil.sh";
    github = "ornxka";
    githubId = 52086525;
    name = "ornxka";
  };
  oro = {
    email = "marco@orovecchia.at";
    github = "oro";
    githubId = 357005;
    name = "Marco Orovecchia";
  };
  osener = {
    email = "ozan@ozansener.com";
    github = "osener";
    githubId = 111265;
    name = "Ozan Sener";
  };
  otavio = {
    email = "otavio.salvador@ossystems.com.br";
    github = "otavio";
    githubId = 25278;
    name = "Otavio Salvador";
  };
  otwieracz = {
    email = "slawek@otwiera.cz";
    github = "otwieracz";
    githubId = 108072;
    name = "Slawomir Gonet";
  };
  oxalica = {
    email = "oxalicc@pm.me";
    github = "oxalica";
    githubId = 14816024;
    name = "oxalica";
    keys = [{
      longkeyid = "rsa4096/0xCED392DE0C483D00";
      fingerprint = "5CB0 E9E5 D5D5 71F5 7F54  0FEA CED3 92DE 0C48 3D00";
    }];
  };
  oxij = {
    email = "oxij@oxij.org";
    github = "oxij";
    githubId = 391919;
    name = "Jan Malakhovski";
    keys = [{
      longkeyid = "rsa2048/0x0E6CA66E5C557AA8";
      fingerprint = "514B B966 B46E 3565 0508  86E8 0E6C A66E 5C55 7AA8";
    }];
  };
  oxzi = {
    email = "post@0x21.biz";
    github = "oxzi";
    githubId = 8402811;
    name = "Alvar Penning";
    keys = [{
      longkeyid = "rsa4096/0xF32A45637FA25E31";
      fingerprint = "EB14 4E67 E57D 27E2 B5A4  CD8C F32A 4563 7FA2 5E31";
    }];
  };
  oyren = {
    email = "m.scheuren@oyra.eu";
    github = "oyren";
    githubId = 15930073;
    name = "Moritz Scheuren";
  };
  pablovsky = {
    email = "dealberapablo07@gmail.com";
    github = "pablo1107";
    githubId = 17091659;
    name = "Pablo Andres Dealbera";
  };
  pacien = {
    email = "b4gx3q.nixpkgs@pacien.net";
    github = "pacien";
    githubId = 1449319;
    name = "Pacien Tran-Girard";
  };
  pacman99 = {
    email = "pachum99@gmail.com";
    matrix = "@pachumicchu:myrdd.info";
    github = "Pacman99";
    githubId = 16345849;
    name = "Parthiv Seetharaman";
  };
  paddygord = {
    email = "pgpatrickgordon@gmail.com";
    github = "paddygord";
    githubId = 10776658;
    name = "Patrick Gordon";
  };
  paholg = {
    email = "paho@paholg.com";
    github = "paholg";
    githubId = 4908217;
    name = "Paho Lurie-Gregg";
  };
  pakhfn = {
    email = "pakhfn@gmail.com";
    github = "pakhfn";
    githubId = 11016164;
    name = "Fedor Pakhomov";
  };
  paluh = {
    email = "paluho@gmail.com";
    github = "paluh";
    githubId = 190249;
    name = "Tomasz Rybarczyk";
  };
  pamplemousse = {
    email = "xav.maso@gmail.com";
    matrix = "@pamplemouss_:matrix.org";
    github = "Pamplemousse";
    githubId = 2647236;
    name = "Xavier Maso";
  };
  panaeon = {
    email = "vitalii.voloshyn@gmail.com";
    github = "panaeon";
    githubId = 686076;
    name = "Vitalii Voloshyn";
  };
  pandaman = {
    email = "kointosudesuyo@infoseek.jp";
    github = "pandaman64";
    githubId = 1788628;
    name = "pandaman";
  };
  paperdigits = {
    email = "mica@silentumbrella.com";
    github = "paperdigits";
    githubId = 71795;
    name = "Mica Semrick";
  };
  paraseba = {
    email = "paraseba@gmail.com";
    github = "paraseba";
    githubId = 20792;
    name = "Sebastian Galkin";
  };
  parasrah = {
    email = "nixos@parasrah.com";
    github = "parasrah";
    githubId = 14935550;
    name = "Brad Pfannmuller";
  };
  pashashocky = {
    email = "pashashocky@gmail.com";
    github = "pashashocky";
    githubId = 673857;
    name = "Pash Shocky";
  };
  pashev = {
    email = "pashev.igor@gmail.com";
    github = "ip1981";
    githubId = 131844;
    name = "Igor Pashev";
  };
  pasqui23 = {
    email = "p3dimaria@hotmail.it";
    github = "pasqui23";
    githubId = 6931743;
    name = "pasqui23";
  };
  patryk27 = {
    email = "pwychowaniec@pm.me";
    github = "Patryk27";
    githubId = 3395477;
    name = "Patryk Wychowaniec";
    keys = [{
      longkeyid = "rsa4096/0xF62547D075E09767";
      fingerprint = "196A BFEC 6A1D D1EC 7594  F8D1 F625 47D0 75E0 9767";
    }];
  };
  patternspandemic = {
    email = "patternspandemic@live.com";
    github = "patternspandemic";
    githubId = 15645854;
    name = "Brad Christensen";
  };
  payas = {
    email = "relekarpayas@gmail.com";
    github = "payasrelekar";
    githubId = 24254289;
    name = "Payas Relekar";
  };
  pawelpacana = {
    email = "pawel.pacana@gmail.com";
    github = "pawelpacana";
    githubId = 116740;
    name = "Paweł Pacana";
  };
  pb- = {
    email = "pbaecher@gmail.com";
    github = "pb-";
    githubId = 84886;
    name = "Paul Baecher";
  };
  pbogdan = {
    email = "ppbogdan@gmail.com";
    github = "pbogdan";
    githubId = 157610;
    name = "Piotr Bogdan";
  };
  pborzenkov = {
    email = "pavel@borzenkov.net";
    github = "pborzenkov";
    githubId = 434254;
    name = "Pavel Borzenkov";
  };
  pblkt = {
    email = "pebblekite@gmail.com";
    github = "pblkt";
    githubId = 6498458;
    name = "pebble kite";
  };
  pcarrier = {
    email = "pc@rrier.ca";
    github = "pcarrier";
    githubId = 8641;
    name = "Pierre Carrier";
  };
  penguwin = {
    email = "penguwin@penguwin.eu";
    github = "penguwin";
    githubId = 13225611;
    name = "Nicolas Martin";
  };
  pennae = {
    name = "pennae";
    email = "github@quasiparticle.net";
    github = "pennae";
    githubId = 82953136;
  };
  p3psi = {
    name = "Elliot Boo";
    email = "p3psi.boo@gmail.com";
    github = "p3psi-boo";
    githubId = 43925055;
  };
  periklis = {
    email = "theopompos@gmail.com";
    github = "periklis";
    githubId = 152312;
    name = "Periklis Tsirakidis";
  };
  petabyteboy = {
    email = "milan@petabyte.dev";
    matrix = "@milan:petabyte.dev";
    github = "petabyteboy";
    githubId = 3250809;
    name = "Milan Pässler";
  };
  petercommand = {
    email = "petercommand@gmail.com";
    github = "petercommand";
    githubId = 1260660;
    name = "petercommand";
  };
  peterhoeg = {
    email = "peter@hoeg.com";
    matrix = "@peter:hoeg.com";
    github = "peterhoeg";
    githubId = 722550;
    name = "Peter Hoeg";
  };
  peterromfeldhk = {
    email = "peter.romfeld.hk@gmail.com";
    github = "peterromfeldhk";
    githubId = 5515707;
    name = "Peter Romfeld";
  };
  petersjt014 = {
    email = "petersjt014@gmail.com";
    github = "petersjt014";
    githubId = 29493551;
    name = "Josh Peters";
  };
  peti = {
    email = "simons@cryp.to";
    github = "peti";
    githubId = 28323;
    name = "Peter Simons";
  };
  petrosagg = {
    email = "petrosagg@gmail.com";
    github = "petrosagg";
    githubId = 939420;
    name = "Petros Angelatos";
  };
  petterstorvik = {
    email = "petterstorvik@gmail.com";
    github = "storvik";
    githubId = 3438604;
    name = "Petter Storvik";
  };
  p-h = {
    email = "p@hurlimann.org";
    github = "p-h";
    githubId = 645664;
    name = "Philippe Hürlimann";
  };
  philandstuff = {
    email = "philip.g.potter@gmail.com";
    github = "philandstuff";
    githubId = 581269;
    name = "Philip Potter";
  };
  phile314 = {
    email = "nix@314.ch";
    github = "phile314";
    githubId = 1640697;
    name = "Philipp Hausmann";
  };
  Philipp-M = {
    email = "philipp@mildenberger.me";
    github = "Philipp-M";
    githubId = 9267430;
    name = "Philipp Mildenberger";
  };
  Phlogistique = {
    email = "noe.rubinstein@gmail.com";
    github = "Phlogistique";
    githubId = 421510;
    name = "Noé Rubinstein";
  };
  photex = {
    email = "photex@gmail.com";
    github = "photex";
    githubId = 301903;
    name = "Chip Collier";
  };
  phryneas = {
    email = "mail@lenzw.de";
    github = "phryneas";
    githubId = 4282439;
    name = "Lenz Weber";
  };
  phunehehe = {
    email = "phunehehe@gmail.com";
    github = "phunehehe";
    githubId = 627831;
    name = "Hoang Xuan Phu";
  };
  piegames = {
    name = "piegames";
    email = "nix@piegames.de";
    matrix = "@piegames:matrix.org";
    github = "piegamesde";
    githubId = 14054505;
  };
  pierrechevalier83 = {
    email = "pierrechevalier83@gmail.com";
    github = "pierrechevalier83";
    githubId = 5790907;
    name = "Pierre Chevalier";
  };
  pierreis = {
    email = "pierre@pierre.is";
    github = "pierreis";
    githubId = 203973;
    name = "Pierre Matri";
  };
  pierrer = {
    email = "pierrer@pi3r.be";
    github = "pierrer";
    githubId = 93115;
    name = "Pierre Radermecker";
  };
  pierron = {
    email = "nixos@nbp.name";
    github = "nbp";
    githubId = 1179566;
    name = "Nicolas B. Pierron";
  };
  pimeys = {
    email = "julius@nauk.io";
    github = "pimeys";
    githubId = 34967;
    name = "Julius de Bruijn";
  };
  pingiun = {
    email = "nixos@pingiun.com";
    github = "pingiun";
    githubId = 1576660;
    name = "Jelle Besseling";
    keys = [{
      longkeyid = "rsa4096/0x9712452E8BE3372E";
      fingerprint = "A3A3 65AE 16ED A7A0 C29C  88F1 9712 452E 8BE3 372E";
    }];
  };
  pinpox = {
    email = "mail@pablo.tools";
    github = "pinpox";
    githubId = 1719781;
    name = "Pablo Ovelleiro Corral";
    keys = [{
      longkeyid = "rsa4096/0x823A6154426408D3";
      fingerprint = "D03B 218C AE77 1F77 D7F9  20D9 823A 6154 4264 08D3";
    }];
  };
  piotr = {
    email = "ppietrasa@gmail.com";
    name = "Piotr Pietraszkiewicz";
  };
  pjbarnoy = {
    email = "pjbarnoy@gmail.com";
    github = "pjbarnoy";
    githubId = 119460;
    name = "Perry Barnoy";
  };
  pjjw = {
    email = "peter@shortbus.org";
    github = "pjjw";
    githubId = 638;
    name = "Peter Woodman";
  };
  pjones = {
    email = "pjones@devalot.com";
    github = "pjones";
    githubId = 3737;
    name = "Peter Jones";
  };
  pkmx = {
    email = "pkmx.tw@gmail.com";
    github = "pkmx";
    githubId = 610615;
    name = "Chih-Mao Chen";
  };
  plabadens = {
    name = "Pierre Labadens";
    email = "labadens.pierre+nixpkgs@gmail.com";
    github = "plabadens";
    githubId = 4303706;
    keys = [{
      longkeyid = "rsa2048/0xF55814E4D6874375";
      fingerprint = "B00F E582 FD3F 0732 EA48  3937 F558 14E4 D687 4375";
    }];
  };
  plchldr = {
    email = "mail@oddco.de";
    github = "plchldr";
    githubId = 11639001;
    name = "Jonas Beyer";
  };
  plcplc = {
    email = "plcplc@gmail.com";
    github = "plcplc";
    githubId = 358550;
    name = "Philip Lykke Carlsen";
  };
  plumps = {
    email = "maks.bronsky@web.de";
    github = "plumps";
    githubId = 13000278;
    name = "Maksim Bronsky";
  };
  PlushBeaver = {
    name = "Dmitry Kozlyuk";
    email = "dmitry.kozliuk+nixpkgs@gmail.com";
    github = "PlushBeaver";
    githubId = 8988269;
  };
  pmahoney = {
    email = "pat@polycrystal.org";
    github = "pmahoney";
    githubId = 103822;
    name = "Patrick Mahoney";
  };
  pmenke = {
    email = "nixos@pmenke.de";
    github = "pmenke-de";
    githubId = 898922;
    name = "Philipp Menke";
    keys = [{
      longkeyid = "rsa4096/0xEB7F2D4CCBE23B69";
      fingerprint = "ED54 5EFD 64B6 B5AA EC61 8C16 EB7F 2D4C CBE2 3B69";
    }];
  };
  pmeunier = {
    email = "pierre-etienne.meunier@inria.fr";
    github = "P-E-Meunier";
    githubId = 17021304;
    name = "Pierre-Étienne Meunier";
  };
  pmiddend = {
    email = "pmidden@secure.mailbox.org";
    github = "pmiddend";
    githubId = 178496;
    name = "Philipp Middendorf";
  };
  pmy = {
    email = "pmy@xqzp.net";
    github = "pmeiyu";
    githubId = 8529551;
    name = "Peng Mei Yu";
  };
  pmyjavec = {
    email = "pauly@myjavec.com";
    github = "pmyjavec";
    githubId = 315096;
    name = "Pauly Myjavec";
  };
  pnelson = {
    email = "me@pnelson.ca";
    github = "pnelson";
    githubId = 579773;
    name = "Philip Nelson";
  };
  pneumaticat = {
    email = "kevin@potatofrom.space";
    github = "pneumaticat";
    githubId = 11365056;
    name = "Kevin Liu";
  };
  pnmadelaine = {
    name = "Paul-Nicolas Madelaine";
    email = "pnm@pnm.tf";
    github = "pnmadelaine";
    githubId = 21977014;
  };
  pnotequalnp = {
    email = "kevin@pnotequalnp.com";
    github = "pnotequalnp";
    githubId = 46154511;
    name = "Kevin Mullins";
    keys = [{
      longkeyid = "rsa4096/361820A45DB41E9A";
      fingerprint = "2CD2 B030 BD22 32EF DF5A  008A 3618 20A4 5DB4 1E9A";
    }];
  };
  polendri = {
    email = "paul@ijj.li";
    github = "polendri";
    githubId = 1829032;
    name = "Paul Hendry";
  };
  polygon = {
    email = "polygon@wh2.tu-dresden.de";
    name = "Polygon";
    github = "polygon";
    githubId = 51489;
  };
  polykernel = {
    email = "81340136+polykernel@users.noreply.github.com";
    github = "polykernel";
    githubId = 81340136;
    name = "polykernel";
  };
  polyrod = {
    email = "dc1mdp@gmail.com";
    github = "polyrod";
    githubId = 24878306;
    name = "Maurizio Di Pietro";
  };
  pombeirp = {
    email = "nix@endgr.33mail.com";
    github = "PombeirP";
    githubId = 138074;
    name = "Pedro Pombeiro";
  };
  poscat = {
    email = "poscat@mail.poscat.moe";
    github = "poscat0x04";
    githubId = 53291983;
    name = "Poscat Tarski";
    keys = [{
      longkeyid = "rsa4096/2D2595A00D08ACE0";
      fingerprint = "48AD DE10 F27B AFB4 7BB0  CCAF 2D25 95A0 0D08 ACE0";
    }];
  };
  ppom = {
    name = "Paco Pompeani";
    email = "paco@ecomail.io";
    github = "aopom";
    githubId = 38916722;
  };
  pradeepchhetri = {
    email = "pradeep.chhetri89@gmail.com";
    github = "pradeepchhetri";
    githubId = 2232667;
    name = "Pradeep Chhetri";
  };
  pradyuman = {
    email = "me@pradyuman.co";
    github = "pradyuman";
    githubId = 9904569;
    name = "Pradyuman Vig";
    keys = [{
      longkeyid = "rsa4096/4F74D5361C4CA31E";
      fingerprint = "240B 57DE 4271 2480 7CE3  EAC8 4F74 D536 1C4C A31E";
    }];
  };
  preisschild = {
    email = "florian@florianstroeger.com";
    github = "Preisschild";
    githubId = 11898437;
    name = "Florian Ströger";
  };
  priegger = {
    email = "philipp@riegger.name";
    github = "priegger";
    githubId = 228931;
    name = "Philipp Riegger";
  };
  prikhi = {
    email = "pavan.rikhi@gmail.com";
    github = "prikhi";
    githubId = 1304102;
    name = "Pavan Rikhi";
  };
  primeos = {
    email = "dev.primeos@gmail.com";
    matrix = "@primeos:matrix.org";
    github = "primeos";
    githubId = 7537109;
    name = "Michael Weiss";
    keys = [
      {
        longkeyid = "ed25519/0x130826A6C2A389FD"; # Git only
        fingerprint = "86A7 4A55 07D0 58D1 322E  37FD 1308 26A6 C2A3 89FD";
      }
      {
        longkeyid = "rsa3072/0xBCA9943DD1DF4C04"; # Email, etc.
        fingerprint = "AF85 991C C950 49A2 4205  1933 BCA9 943D D1DF 4C04";
      }
    ];
  };
  Profpatsch = {
    email = "mail@profpatsch.de";
    github = "Profpatsch";
    githubId = 3153638;
    name = "Profpatsch";
  };
  proglodyte = {
    email = "proglodyte23@gmail.com";
    github = "proglodyte";
    githubId = 18549627;
    name = "Proglodyte";
  };
  progval = {
    email = "progval+nix@progval.net";
    github = "ProgVal";
    githubId = 406946;
    name = "Valentin Lorentz";
  };
  proofofkeags = {
    email = "keagan.mcclelland@gmail.com";
    github = "ProofOfKeags";
    githubId = 4033651;
    name = "Keagan McClelland";
  };
  protoben = {
    email = "protob3n@gmail.com";
    github = "protoben";
    githubId = 4633847;
    name = "Ben Hamlin";
  };
  prusnak = {
    email = "pavol@rusnak.io";
    github = "prusnak";
    githubId = 42201;
    name = "Pavol Rusnak";
    keys = [{
      longkeyid = "rsa4096/0x91F3B339B9A02A3D";
      fingerprint = "86E6 792F C27B FD47 8860  C110 91F3 B339 B9A0 2A3D";
    }];
  };
  psanford = {
    email = "psanford@sanford.io";
    github = "psanford";
    githubId = 33375;
    name = "Peter Sanford";
  };
  pshirshov = {
    email = "pshirshov@eml.cc";
    github = "pshirshov";
    githubId = 295225;
    name = "Pavel Shirshov";
  };
  psibi = {
    email = "sibi@psibi.in";
    matrix = "@psibi:matrix.org";
    github = "psibi";
    githubId = 737477;
    name = "Sibi Prabakaran";
  };
  pstn = {
    email = "philipp@xndr.de";
    github = "pstn";
    githubId = 1329940;
    name = "Philipp Steinpaß";
  };
  pSub = {
    email = "mail@pascal-wittmann.de";
    github = "pSub";
    githubId = 83842;
    name = "Pascal Wittmann";
  };
  psyanticy = {
    email = "iuns@outlook.fr";
    github = "PsyanticY";
    githubId = 20524473;
    name = "Psyanticy";
  };
  ptival = {
    email = "valentin.robert.42@gmail.com";
    github = "Ptival";
    githubId = 478606;
    name = "Valentin Robert";
  };
  ptrhlm = {
    email = "ptrhlm0@gmail.com";
    github = "ptrhlm";
    githubId = 9568176;
    name = "Piotr Halama";
  };
  puckipedia = {
    email = "puck@puckipedia.com";
    github = "puckipedia";
    githubId = 488734;
    name = "Puck Meerburg";
  };
  puffnfresh = {
    email = "brian@brianmckenna.org";
    github = "puffnfresh";
    githubId = 37715;
    name = "Brian McKenna";
  };
  purcell = {
    email = "steve@sanityinc.com";
    github = "purcell";
    githubId = 5636;
    name = "Steve Purcell";
  };
  putchar = {
    email = "slim.cadoux@gmail.com";
    matrix = "@putch4r:matrix.org";
    github = "putchar";
    githubId = 8208767;
    name = "Slim Cadoux";
  };
  puzzlewolf = {
    email = "nixos@nora.pink";
    github = "puzzlewolf";
    githubId = 23097564;
    name = "Nora Widdecke";
  };
  pyrolagus = {
    email = "pyrolagus@gmail.com";
    github = "PyroLagus";
    githubId = 4579165;
    name = "Danny Bautista";
  };
  peelz = {
    email = "peelz.dev+nixpkgs@gmail.com";
    github = "louistakepillz";
    githubId = 920910;
    name = "peelz";
  };
  q3k = {
    email = "q3k@q3k.org";
    github = "q3k";
    githubId = 315234;
    name = "Serge Bazanski";
  };
  qknight = {
    email = "js@lastlog.de";
    github = "qknight";
    githubId = 137406;
    name = "Joachim Schiele";
  };
  qoelet = {
    email = "kenny@machinesung.com";
    github = "qoelet";
    githubId = 115877;
    name = "Kenny Shen";
  };
  queezle = {
    email = "git@queezle.net";
    github = "qzle";
    githubId = 1024891;
    name = "Jens Nolte";
  };
  quentini = {
    email = "quentini@airmail.cc";
    github = "QuentinI";
    githubId = 18196237;
    name = "Quentin Inkling";
  };
  qyliss = {
    email = "hi@alyssa.is";
    github = "alyssais";
    githubId = 2768870;
    name = "Alyssa Ross";
    keys = [{
      longkeyid = "rsa4096/736CCDF9EF51BD97";
      fingerprint = "7573 56D7 79BB B888 773E  415E 736C CDF9 EF51 BD97";
    }];
  };
  r-burns = {
    email = "rtburns@protonmail.com";
    github = "r-burns";
    githubId = 52847440;
    name = "Ryan Burns";
  };
  r3dl3g = {
    email = "redleg@rothfuss-web.de";
    github = "r3dl3g";
    githubId = 35229674;
    name = "Armin Rothfuss";
  };
  raboof = {
    email = "arnout@bzzt.net";
    matrix = "@raboof:matrix.org";
    github = "raboof";
    githubId = 131856;
    name = "Arnout Engelen";
  };
  RaghavSood = {
    email = "r@raghavsood.com";
    github = "RaghavSood";
    githubId = 903072;
    name = "Raghav Sood";
  };
  rafaelgg = {
    email = "rafael.garcia.gallego@gmail.com";
    github = "rafaelgg";
    githubId = 1016742;
    name = "Rafael García";
  };
  raitobezarius = {
    email = "ryan@lahfa.xyz";
    matrix = "@raitobezarius:matrix.org";
    github = "RaitoBezarius";
    githubId = 314564;
    name = "Ryan Lahfa";
  };
  raquelgb = {
    email = "raquel.garcia.bautista@gmail.com";
    github = "raquelgb";
    githubId = 1246959;
    name = "Raquel García";
  };
  ragge = {
    email = "r.dahlen@gmail.com";
    github = "ragnard";
    githubId = 882;
    name = "Ragnar Dahlen";
  };
  ralith = {
    email = "ben.e.saunders@gmail.com";
    matrix = "@ralith:ralith.com";
    github = "ralith";
    githubId = 104558;
    name = "Benjamin Saunders";
  };
  ramkromberg = {
    email = "ramkromberg@mail.com";
    github = "ramkromberg";
    githubId = 14829269;
    name = "Ram Kromberg";
  };
  ranfdev = {
    email = "ranfdev@gmail.com";
    name = "Lorenzo Miglietta";
    github = "ranfdev";
    githubId = 23294184;
  };
  rardiol = {
    email = "ricardo.ardissone@gmail.com";
    github = "rardiol";
    githubId = 11351304;
    name = "Ricardo Ardissone";
  };
  rasendubi = {
    email = "rasen.dubi@gmail.com";
    github = "rasendubi";
    githubId = 1366419;
    name = "Alexey Shmalko";
  };
  raskin = {
    email = "7c6f434c@mail.ru";
    github = "7c6f434c";
    githubId = 1891350;
    name = "Michael Raskin";
  };
  ratsclub = {
    email = "victor@freire.dev.br";
    github = "ratsclub";
    githubId = 25647735;
    name = "Victor Freire";
  };
  ravloony = {
    email = "ravloony@gmail.com";
    name = "Tom Macdonald";
  };
  rawkode = {
    email = "david.andrew.mckay@gmail.com";
    github = "rawkode";
    githubId = 145816;
    name = "David McKay";
  };
  razvan = {
    email = "razvan.panda@gmail.com";
    github = "razvan-panda";
    githubId = 1758708;
    name = "Răzvan Flavius Panda";
  };
  rb2k = {
    email = "nix@marc-seeger.com";
    github = "rb2k";
    githubId = 9519;
    name = "Marc Seeger";
  };
  rbasso = {
    email = "rbasso@sharpgeeks.net";
    github = "rbasso";
    githubId = 16487165;
    name = "Rafael Basso";
  };
  rbrewer = {
    email = "rwb123@gmail.com";
    github = "rbrewer123";
    githubId = 743058;
    name = "Rob Brewer";
  };
  rdnetto = {
    email = "rdnetto@gmail.com";
    github = "rdnetto";
    githubId = 1973389;
    name = "Reuben D'Netto";
  };
  redbaron = {
    email = "ivanov.maxim@gmail.com";
    github = "redbaron";
    githubId = 16624;
    name = "Maxim Ivanov";
  };
  redfish64 = {
    email = "engler@gmail.com";
    github = "redfish64";
    githubId = 1922770;
    name = "Tim Engler";
  };
  redvers = {
    email = "red@infect.me";
    github = "redvers";
    githubId = 816465;
    name = "Redvers Davies";
  };
  reedrw = {
    email = "reedrw5601@gmail.com";
    github = "reedrw";
    githubId = 21069876;
    name = "Reed Williams";
  };
  refnil = {
    email = "broemartino@gmail.com";
    github = "refnil";
    githubId = 1142322;
    name = "Martin Lavoie";
  };
  regnat = {
    email = "regnat@regnat.ovh";
    github = "regnat";
    githubId = 7226587;
    name = "Théophane Hufschmitt";
  };
  relrod = {
    email = "ricky@elrod.me";
    github = "relrod";
    githubId = 43930;
    name = "Ricky Elrod";
  };
  rembo10 = {
    email = "rembo10@users.noreply.github.com";
    github = "rembo10";
    githubId = 801525;
    name = "rembo10";
  };
  renatoGarcia = {
    email = "fgarcia.renato@gmail.com";
    github = "renatoGarcia";
    githubId = 220211;
    name = "Renato Garcia";
  };
  rencire = {
    email = "546296+rencire@users.noreply.github.com";
    github = "rencire";
    githubId = 546296;
    name = "Eric Ren";
  };
  renesat = {
    name = "Ivan Smolyakov";
    email = "smol.ivan97@gmail.com";
    github = "renesat";
    githubId = 11363539;
  };
  renzo = {
    email = "renzocarbonara@gmail.com";
    github = "k0001";
    githubId = 3302;
    name = "Renzo Carbonara";
  };
  retrry = {
    email = "retrry@gmail.com";
    github = "retrry";
    githubId = 500703;
    name = "Tadas Barzdžius";
  };
  revol-xut = {
    email = "revol-xut@protonmail.com";
    name = "Tassilo Tanneberger";
    github = "revol-xut";
    githubId = 32239737;
    keys = [{
      longkeyid = "rsa4096/B966009D57E69CC6";
      fingerprint = "91EB E870 1639 1323 642A  6803 B966 009D 57E6 9CC6";
    }];
  };
  rexim = {
    email = "reximkut@gmail.com";
    github = "rexim";
    githubId = 165283;
    name = "Alexey Kutepov";
  };
  rewine = {
    email = "lhongxu@outlook.com";
    github = "wineee";
    githubId = 22803888;
    name = "Lu Hongxu";
  };
  rgrunbla = {
    email = "remy@grunblatt.org";
    github = "rgrunbla";
    githubId = 42433779;
    name = "Rémy Grünblatt";
  };
  rguevara84 = {
    email = "fuzztkd@gmail.com";
    github = "rguevara84";
    githubId = 12279531;
    name = "Ricardo Guevara";
  };
  rht = {
    email = "rhtbot@protonmail.com";
    github = "rht";
    githubId = 395821;
    name = "rht";
  };
  rhoriguchi = {
    email = "ryan.horiguchi@gmail.com";
    github = "rhoriguchi ";
    githubId = 6047658;
    name = "Ryan Horiguchi";
  };
  ribose-jeffreylau = {
    name = "Jeffrey Lau";
    email = "jeffrey.lau@ribose.com";
    github = "ribose-jeffreylau";
    githubId = 2649467;
  };
  richardipsum = {
    email = "richardipsum@fastmail.co.uk";
    github = "richardipsum";
    githubId = 10631029;
    name = "Richard Ipsum";
  };
  rick68 = {
    email = "rick68@gmail.com";
    github = "rick68";
    githubId = 42619;
    name = "Wei-Ming Yang";
  };
  rickynils = {
    email = "rickynils@gmail.com";
    github = "rickynils";
    githubId = 16779;
    name = "Rickard Nilsson";
  };
  ricochet = {
    email = "behayes2@gmail.com";
    github = "ricochet";
    githubId = 974323;
    matrix = "@ricochetcode:matrix.org";
    name = "Bailey Hayes";
  };
  riey = {
    email = "creeper844@gmail.com";
    github = "Riey";
    githubId = 14910534;
    name = "Riey";
  };
  rika = {
    email = "rika@paymentswit.ch";
    github = "NekomimiScience";
    githubId = 1810487;
    name = "Rika";
  };
  rileyinman = {
    email = "rileyminman@gmail.com";
    github = "rileyinman";
    githubId = 37246692;
    name = "Riley Inman";
  };
  riotbib = {
    email = "github-nix@lnrt.de";
    github = "riotbib";
    githubId = 43172581;
    name = "Lennart Mühlenmeier";
  };
  ris = {
    email = "code@humanleg.org.uk";
    github = "risicle";
    githubId = 807447;
    name = "Robert Scott";
  };
  risson = {
    name = "Marc Schmitt";
    email = "marc.schmitt@risson.space";
    matrix = "@risson:lama-corp.space";
    github = "rissson";
    githubId = 18313093;
    keys = [
      {
        longkeyid = "rsa4096/0xF6FD87B15C263EC9";
        fingerprint = "8A0E 6A7C 08AB B9DE 67DE  2A13 F6FD 87B1 5C26 3EC9";
      }
      {
        longkeyid = "ed25519/0xBBB7A6801DF1E03F";
        fingerprint = "C0A7 A9BB 115B C857 4D75  EA99 BBB7 A680 1DF1 E03F";
      }
    ];
  };
  rixed = {
    email = "rixed-github@happyleptic.org";
    github = "rixed";
    githubId = 449990;
    name = "Cedric Cellier";
  };
  rkitover = {
    email = "rkitover@gmail.com";
    github = "rkitover";
    githubId = 77611;
    name = "Rafael Kitover";
  };
  rkoe = {
    email = "rk@simple-is-better.org";
    github = "rkoe";
    githubId = 2507744;
    name = "Roland Koebler";
  };
  rizary = {
    email = "andika@numtide.com";
    github = "Rizary";
    githubId = 7221768;
    name = "Andika Demas Riyandi";
  };
  rkrzr = {
    email = "ops+nixpkgs@channable.com";
    github = "rkrzr";
    githubId = 82817;
    name = "Robert Kreuzer";
  };
  rlupton20 = {
    email = "richard.lupton@gmail.com";
    github = "rlupton20";
    githubId = 13752145;
    name = "Richard Lupton";
  };
  rmcgibbo = {
    email = "rmcgibbo@gmail.com";
    matrix = "@rmcgibbo:matrix.org";
    github = "rmcgibbo";
    githubId = 641278;
    name = "Robert T. McGibbon";
  };
  rnhmjoj = {
    email = "rnhmjoj@inventati.org";
    matrix = "@rnhmjoj:maxwell.ydns.eu";
    github = "rnhmjoj";
    githubId = 2817565;
    name = "Michele Guerini Rocco";
    keys = [{
      longkeyid = "ed25519/0xBFBAF4C975F76450";
      fingerprint = "92B2 904F D293 C94D C4C9  3E6B BFBA F4C9 75F7 6450";
    }];
  };
  roastiek = {
    email = "r.dee.b.b@gmail.com";
    github = "roastiek";
    githubId = 422802;
    name = "Rostislav Beneš";
  };
  rob = {
    email = "rob.vermaas@gmail.com";
    github = "rbvermaa";
    githubId = 353885;
    name = "Rob Vermaas";
  };
  robaca = {
    email = "carsten@r0hrbach.de";
    github = "robaca";
    githubId = 580474;
    name = "Carsten Rohrbach";
  };
  robberer = {
    email = "robberer@freakmail.de";
    github = "robberer";
    githubId = 6204883;
    name = "Longrin Wischnewski";
  };
  robbinch = {
    email = "robbinch33@gmail.com";
    github = "robbinch";
    githubId = 12312980;
    name = "Robbin C.";
  };
  roberth = {
    email = "nixpkgs@roberthensing.nl";
    matrix = "@roberthensing:matrix.org";
    github = "roberth";
    githubId = 496447;
    name = "Robert Hensing";
  };
  robertodr = {
    email = "roberto.diremigio@gmail.com";
    github = "robertodr";
    githubId = 3708689;
    name = "Roberto Di Remigio";
  };
  robertoszek = {
    email = "robertoszek@robertoszek.xyz";
    github = "robertoszek";
    githubId = 1080963;
    name = "Roberto";
  };
  robgssp = {
    email = "robgssp@gmail.com";
    github = "robgssp";
    githubId = 521306;
    name = "Rob Glossop";
  };
  roblabla = {
    email = "robinlambertz+dev@gmail.com";
    github = "roblabla";
    githubId = 1069318;
    name = "Robin Lambertz";
  };
  roconnor = {
    email = "roconnor@theorem.ca";
    github = "roconnor";
    githubId = 852967;
    name = "Russell O'Connor";
  };
  roelvandijk = {
    email = "roel@lambdacube.nl";
    github = "roelvandijk";
    githubId = 710906;
    name = "Roel van Dijk";
  };
  romildo = {
    email = "malaquias@gmail.com";
    github = "romildo";
    githubId = 1217934;
    name = "José Romildo Malaquias";
  };
  ronanmacf = {
    email = "macfhlar@tcd.ie";
    github = "ronanmacf";
    githubId = 25930627;
    name = "Ronan Mac Fhlannchadha";
  };
  rongcuid = {
    email = "rongcuid@outlook.com";
    github = "rongcuid";
    githubId = 1312525;
    name = "Rongcui Dong";
  };
  roosemberth = {
    email = "roosembert.palacios+nixpkgs@posteo.ch";
    matrix = "@roosemberth:orbstheorem.ch";
    github = "roosemberth";
    githubId = 3621083;
    name = "Roosembert (Roosemberth) Palacios";
    keys = [{
      longkeyid = "rsa2048/0xCAAAECE5C2242BB7";
      fingerprint = "78D9 1871 D059 663B 6117  7532 CAAA ECE5 C224 2BB7";
    }];
  };
  rople380 = {
    name = "rople380";
    email = "55679162+rople380@users.noreply.github.com";
    github = "rople380";
    githubId = 55679162;
    keys = [{
      longkeyid = "rsa2048/0x8526B7574A536236";
      fingerprint = "1401 1B63 393D 16C1 AA9C  C521 8526 B757 4A53 6236";
    }];
  };
  rowanG077 = {
    email = "goemansrowan@gmail.com";
    github = "rowanG077";
    githubId = 7439756;
    name = "Rowan Goemans";
  };
  royneary = {
    email = "christian@ulrich.earth";
    github = "royneary";
    githubId = 1942810;
    name = "Christian Ulrich";
  };
  rpearce = {
    email = "me@robertwpearce.com";
    github = "rpearce";
    githubId = 592876;
    name = "Robert W. Pearce";
  };
  rprecenth = {
    email = "rasmus@precenth.eu";
    github = "Prillan";
    githubId = 1675190;
    name = "Rasmus Précenth";
  };
  rprospero = {
    email = "rprospero+nix@gmail.com";
    github = "rprospero";
    githubId = 1728853;
    name = "Adam Washington";
  };
  rps = {
    email = "robbpseaton@gmail.com";
    github = "robertseaton";
    githubId = 221121;
    name = "Robert P. Seaton";
  };
  rraval = {
    email = "ronuk.raval@gmail.com";
    github = "rraval";
    githubId = 373566;
    name = "Ronuk Raval";
  };
  rski = {
    name = "rski";
    email = "rom.skiad+nix@gmail.com";
    github = "rski";
    githubId = 2960312;
  };
  rszibele = {
    email = "richard@szibele.com";
    github = "rszibele";
    githubId = 1387224;
    name = "Richard Szibele";
  };
  rsynnest = {
    email = "contact@rsynnest.com";
    github = "rsynnest";
    githubId = 4392850;
    name = "Roland Synnestvedt";
  };
  rtburns-jpl = {
    email = "rtburns@jpl.nasa.gov";
    github = "rtburns-jpl";
    githubId = 47790121;
    name = "Ryan Burns";
  };
  rtreffer = {
    email = "treffer+nixos@measite.de";
    github = "rtreffer";
    githubId = 61306;
    name = "Rene Treffer";
  };
  rushmorem = {
    email = "rushmore@webenchanter.com";
    github = "rushmorem";
    githubId = 4958190;
    name = "Rushmore Mushambi";
  };
  russell = {
    email = "russell.sim@gmail.com";
    github = "russell";
    githubId = 2660;
    name = "Russell Sim";
  };
  ruuda = {
    email = "dev+nix@veniogames.com";
    github = "ruuda";
    githubId = 506953;
    name = "Ruud van Asseldonk";
  };
  rvarago = {
    email = "rafael.varago@gmail.com";
    github = "rvarago";
    githubId = 7365864;
    name = "Rafael Varago";
  };
  rvl = {
    email = "dev+nix@rodney.id.au";
    github = "rvl";
    githubId = 1019641;
    name = "Rodney Lorrimar";
  };
  rvlander = {
    email = "rvlander@gaetanandre.eu";
    github = "rvlander";
    githubId = 5236428;
    name = "Gaëtan André";
  };
  rvolosatovs = {
    email = "rvolosatovs@riseup.net";
    github = "rvolosatovs";
    githubId = 12877905;
    name = "Roman Volosatovs";
  };
  ryanartecona = {
    email = "ryanartecona@gmail.com";
    github = "ryanartecona";
    githubId = 889991;
    name = "Ryan Artecona";
  };
  ryanorendorff = {
    email = "12442942+ryanorendorff@users.noreply.github.com";
    github = "ryanorendorff";
    githubId = 12442942;
    name = "Ryan Orendorff";
  };
  ryansydnor = {
    email = "ryan.t.sydnor@gmail.com";
    github = "ryansydnor";
    githubId = 1832096;
    name = "Ryan Sydnor";
  };
  ryantm = {
    email = "ryan@ryantm.com";
    matrix = "@ryantm:matrix.org";
    github = "ryantm";
    githubId = 4804;
    name = "Ryan Mulligan";
  };
  ryantrinkle = {
    email = "ryan.trinkle@gmail.com";
    github = "ryantrinkle";
    githubId = 1156448;
    name = "Ryan Trinkle";
  };
  rybern = {
    email = "ryan.bernstein@columbia.edu";
    github = "rybern";
    githubId = 4982341;
    name = "Ryan Bernstein";
  };
  rycee = {
    email = "robert@rycee.net";
    github = "rycee";
    githubId = 798147;
    name = "Robert Helgesson";
    keys = [{
      longkeyid = "rsa4096/0x3573356C25C424D4";
      fingerprint = "36CA CF52 D098 CC0E 78FB  0CB1 3573 356C 25C4 24D4";
    }];
  };
  ryneeverett = {
    email = "ryneeverett@gmail.com";
    github = "ryneeverett";
    githubId = 3280280;
    name = "Ryne Everett";
  };
  rytone = {
    email = "max@ryt.one";
    github = "rytone";
    githubId = 8082305;
    name = "Maxwell Beck";
    keys = [{
      longkeyid = "rsa2048/0xBB3EFA303760A0DB";
      fingerprint = "D260 79E3 C2BC 2E43 905B  D057 BB3E FA30 3760 A0DB";
    }];
  };
  rzetterberg = {
    email = "richard.zetterberg@gmail.com";
    github = "rzetterberg";
    githubId = 766350;
    name = "Richard Zetterberg";
  };
  s1341 = {
    email = "s1341@shmarya.net";
    matrix = "@s1341:matrix.org";
    name = "Shmarya Rubenstein";
    github = "s1341";
    githubId = 5682183;
  };
  sagikazarmark = {
    name = "Mark Sagi-Kazar";
    email = "mark.sagikazar@gmail.com";
    matrix = "@mark.sagikazar:matrix.org";
    github = "sagikazarmark";
    githubId = 1226384;
    keys = [{
      longkeyid = "rsa4096/0xF251ADDC9D041C7E";
      fingerprint = "E628 C811 6FB8 1657 F706  4EA4 F251 ADDC 9D04 1C7E";
    }];
  };
  samalws = {
    email = "sam@samalws.com";
    name = "Sam Alws";
    github = "samalws";
    githubId = 20981725;
  };
  samb96 = {
    email = "samb96@gmail.com";
    github = "samb96";
    githubId = 819426;
    name = "Sam Bickley";
  };
  samdoshi = {
    email = "sam@metal-fish.co.uk";
    github = "samdoshi";
    githubId = 112490;
    name = "Sam Doshi";
  };
  samdroid-apps = {
    email = "sam@sam.today";
    github = "samdroid-apps";
    githubId = 6022042;
    name = "Sam Parkinson";
  };
  samlich = {
    email = "nixos@samli.ch";
    github = "samlich";
    githubId = 1349989;
    name = "samlich";
    keys = [{
      longkeyid = "rsa4096/B1568953B1939F1C";
      fingerprint = "AE8C 0836 FDF6 3FFC 9580  C588 B156 8953 B193 9F1C";
    }];
  };
  samrose = {
    email = "samuel.rose@gmail.com";
    github = "samrose";
    githubId = 115821;
    name = "Sam Rose";
  };
  samuela = {
    email = "skainsworth@gmail.com";
    github = "samuela";
    githubId = 226872;
    name = "Samuel Ainsworth";
  };
  samueldr = {
    email = "samuel@dionne-riel.com";
    matrix = "@samueldr:matrix.org";
    github = "samueldr";
    githubId = 132835;
    name = "Samuel Dionne-Riel";
  };
  samuelgrf = {
    email = "s@muel.gr";
    github = "samuelgrf";
    githubId = 67663538;
    name = "Samuel Gräfenstein";
    keys = [
      {
        longkeyid = "rsa4096/0xDE75F92E318123F0";
        fingerprint = "6F2E 2A90 423C 8111 BFF2  895E DE75 F92E 3181 23F0";
      }
      {
        longkeyid = "rsa4096/0xEF76A063F15C63C8";
        fingerprint = "FF24 5832 8FAF 4660 18C6  186E EF76 A063 F15C 63C8";
      }
    ];
  };
  samuelrivas = {
    email = "samuelrivas@gmail.com";
    github = "samuelrivas";
    githubId = 107703;
    name = "Samuel Rivas";
  };
  sander = {
    email = "s.vanderburg@tudelft.nl";
    github = "svanderburg";
    githubId = 1153271;
    name = "Sander van der Burg";
  };
  sarcasticadmin = {
    email = "rob@sarcasticadmin.com";
    github = "sarcasticadmin";
    githubId = 30531572;
    name = "Robert James Hernandez";
  };
  sargon = {
    email = "danielehlers@mindeye.net";
    github = "sargon";
    githubId = 178904;
    name = "Daniel Ehlers";
  };
  saschagrunert = {
    email = "mail@saschagrunert.de";
    github = "saschagrunert";
    githubId = 695473;
    name = "Sascha Grunert";
  };
  sauyon = {
    email = "s@uyon.co";
    github = "sauyon";
    githubId = 2347889;
    name = "Sauyon Lee";
  };
  savannidgerinel = {
    email = "savanni@luminescent-dreams.com";
    github = "savannidgerinel";
    githubId = 8534888;
    name = "Savanni D'Gerinel";
  };
  sayanarijit = {
    email = "sayanarijit@gmail.com";
    github = "sayanarijit";
    githubId = 11632726;
    name = "Arijit Basu";
  };
  sb0 = {
    email = "sb@m-labs.hk";
    github = "sbourdeauducq";
    githubId = 720864;
    name = "Sébastien Bourdeauducq";
  };
  sbellem = {
    email = "sbellem@gmail.com";
    github = "sbellem";
    githubId = 125458;
    name = "Sylvain Bellemare";
  };
  sbond75 = {
    name = "sbond75";
    email = "43617712+sbond75@users.noreply.github.com";
    github = "sbond75";
    githubId = 43617712;
  };
  sboosali = {
    email = "SamBoosalis@gmail.com";
    github = "sboosali";
    githubId = 2320433;
    name = "Sam Boosalis";
  };
  sbruder = {
    email = "nixos@sbruder.de";
    github = "sbruder";
    githubId = 15986681;
    name = "Simon Bruder";
  };
  scalavision = {
    email = "scalavision@gmail.com";
    github = "scalavision";
    githubId = 3958212;
    name = "Tom Sorlie";
  };
  schmitthenner = {
    email = "development@schmitthenner.eu";
    github = "fkz";
    githubId = 354463;
    name = "Fabian Schmitthenner";
  };
  schmittlauch = {
    name = "Trolli Schmittlauch";
    email = "t.schmittlauch+nixos@orlives.de";
    github = "schmittlauch";
    githubId = 1479555;
  };
  schneefux = {
    email = "schneefux+nixos_pkg@schneefux.xyz";
    github = "schneefux";
    githubId = 15379000;
    name = "schneefux";
  };
  schnusch = {
    email = "schnusch@users.noreply.github.com";
    github = "schnusch";
    githubId = 5104601;
    name = "schnusch";
  };
  schristo = {
    email = "schristopher@konputa.com";
    name = "Scott Christopher";
  };
  scode = {
    email = "peter.schuller@infidyne.com";
    github = "scode";
    githubId = 59476;
    name = "Peter Schuller";
  };
  scolobb = {
    email = "sivanov@colimite.fr";
    github = "scolobb";
    githubId = 11320;
    name = "Sergiu Ivanov";
  };
  screendriver = {
    email = "nix@echooff.de";
    github = "screendriver";
    githubId = 149248;
    name = "Christian Rackerseder";
  };
  Scriptkiddi = {
    email = "nixos@scriptkiddi.de";
    matrix = "@fritz.otlinghaus:helsinki-systems.de";
    github = "scriptkiddi";
    githubId = 3598650;
    name = "Fritz Otlinghaus";
  };
  scubed2 = {
    email = "scubed2@gmail.com";
    github = "scubed2";
    githubId = 7401858;
    name = "Sterling Stein";
  };
  sdier = {
    email = "scott@dier.name";
    matrix = "@sdier:matrix.org";
    github = "sdier";
    githubId = 11613056;
    name = "Scott Dier";
  };
  SeanZicari = {
    email = "sean.zicari@gmail.com";
    github = "SeanZicari";
    githubId = 2343853;
    name = "Sean Zicari";
  };
  seb314 = {
    email = "sebastian@seb314.com";
    github = "seb314";
    githubId = 19472270;
    name = "Sebastian";
  };
  sebbadk = {
    email = "sebastian@sebba.dk";
    github = "SEbbaDK";
    githubId = 1567527;
    name = "Sebastian Hyberts";
  };
  sebbel = {
    email = "hej@sebastian-ball.de";
    github = "sebbel";
    githubId = 1940568;
    name = "Sebastian Ball";
  };
  sebtm = {
    email = "mail@sebastian-sellmeier.de";
    github = "sebtm";
    githubId = 17243347;
    name = "Sebastian Sellmeier";
  };
  sellout = {
    email = "greg@technomadic.org";
    github = "sellout";
    githubId = 33031;
    name = "Greg Pfeil";
  };
  sengaya = {
    email = "tlo@sengaya.de";
    github = "sengaya";
    githubId = 1286668;
    name = "Thilo Uttendorfer";
  };
  sephalon = {
    email = "me@sephalon.net";
    github = "sephalon";
    githubId = 893474;
    name = "Stefan Wiehler";
  };
  sepi = {
    email = "raffael@mancini.lu";
    github = "sepi";
    githubId = 529649;
    name = "Raffael Mancini";
  };
  seppeljordan = {
    email = "sebastian.jordan.mail@googlemail.com";
    github = "seppeljordan";
    githubId = 4805746;
    name = "Sebastian Jordan";
  };
  seqizz = {
    email = "seqizz@gmail.com";
    github = "seqizz";
    githubId = 307899;
    name = "Gurkan Gur";
  };
  sersorrel = {
    email = "ash@sorrel.sh";
    github = "sersorrel";
    githubId = 9433472;
    name = "ash";
  };
  servalcatty = {
    email = "servalcat@pm.me";
    github = "servalcatty";
    githubId = 51969817;
    name = "Serval";
    keys = [{
      longkeyid = "rsa4096/0x4A2AAAA382F8294C";
      fingerprint = "A317 37B3 693C 921B 480C  C629 4A2A AAA3 82F8 294C";
    }];
  };
  seylerius = {
    name = "Sable Seyler";
    email = "sable@seyleri.us";
    github = "seylerius";
    githubId = 1145981;
    keys = [{
      longkeyid = "rsa4096/0xDC26B921A9E9DBDE";
      fingerprint = "7246 B6E1 ABB9 9A48 4395  FD11 DC26 B921 A9E9 DBDE";
    }];
  };
  sfrijters = {
    email = "sfrijters@gmail.com";
    github = "sfrijters";
    githubId = 918365;
    name = "Stefan Frijters";
  };
  sgo = {
    email = "stig@stig.io";
    github = "stigtsp";
    githubId = 75371;
    name = "Stig Palmquist";
  };
  sgraf = {
    email = "sgraf1337@gmail.com";
    github = "sgraf812";
    githubId = 1151264;
    name = "Sebastian Graf";
  };
  shahrukh330 = {
    email = "shahrukh330@gmail.com";
    github = "shahrukh330";
    githubId = 1588288;
    name = "Shahrukh Khan";
  };
  shamilton = {
    email = "sgn.hamilton@protonmail.com";
    github = "SCOTT-HAMILTON";
    githubId = 24496705;
    name = "Scott Hamilton";
  };
  ShamrockLee = {
    name = "Shamrock Lee";
    email = "44064051+ShamrockLee@users.noreply.github.com";
    github = "ShamrockLee";
    githubId = 44064051;
  };
  shanemikel = {
    email = "shanepearlman@pm.me";
    github = "shanemikel";
    githubId = 6720672;
    name = "Shane Pearlman";
  };
  shanesveller = {
    email = "shane@sveller.dev";
    github = "shanesveller";
    githubId = 831;
    keys = [{
      longkeyid = "rsa4096/0x9210C218023C15CD";
      fingerprint = "F83C 407C ADC4 5A0F 1F2F  44E8 9210 C218 023C 15CD";
    }];
    name = "Shane Sveller";
  };
  shawndellysse = {
    email = "sdellysse@gmail.com";
    github = "shawndellysse";
    githubId = 293035;
    name = "Shawn Dellysse";
  };
  shazow = {
    email = "andrey.petrov@shazow.net";
    github = "shazow";
    githubId = 6292;
    name = "Andrey Petrov";
  };
  sheenobu = {
    email = "sheena.artrip@gmail.com";
    github = "sheenobu";
    githubId = 1443459;
    name = "Sheena Artrip";
  };
  sheepforce = {
    email = "phillip.seeber@googlemail.com";
    github = "sheepforce";
    githubId = 16844216;
    name = "Phillip Seeber";
  };
  sheganinans = {
    email = "sheganinans@gmail.com";
    github = "sheganinans";
    githubId = 2146203;
    name = "Aistis Raulinaitis";
  };
  shell = {
    email = "cam.turn@gmail.com";
    github = "VShell";
    githubId = 251028;
    name = "Shell Turner";
  };
  shikanime = {
    name = "William Phetsinorath";
    email = "deva.shikanime@protonmail.com";
    github = "shikanime";
    githubId = 22115108;
  };
  shlevy = {
    email = "shea@shealevy.com";
    github = "shlevy";
    githubId = 487050;
    name = "Shea Levy";
  };
  shmish111 = {
    email = "shmish111@gmail.com";
    github = "shmish111";
    githubId = 934267;
    name = "David Smith";
  };
  shnarazk = {
    email = "shujinarazaki@protonmail.com";
    github = "shnarazk";
    githubId = 997855;
    name = "Narazaki Shuji";
  };
  shofius = {
    name = "Sam Hofius";
    email = "sam@samhofi.us";
    github = "kf5grd";
    githubId = 18297490;
  };
  shou = {
    email = "x+g@shou.io";
    github = "Shou";
    githubId = 819413;
    name = "Benedict Aas";
  };
  shreerammodi = {
    name = "Shreeram Modi";
    email = "shreerammodi10@gmail.com";
    github = "Shrimpram";
    githubId = 67710369;
    keys = [{
      longkeyid = "rsa4096/0x163B16EE76ED24CE";
      fingerprint = "EA88 EA07 26E9 6CBF 6365  3966 163B 16EE 76ED 24CE";
    }];
  };
  shyim = {
    email = "s.sayakci@gmail.com";
    github = "shyim";
    githubId = 6224096;
    name = "Soner Sayakci";
  };
  siddharthist = {
    email = "langston.barrett@gmail.com";
    github = "langston-barrett";
    githubId = 4294323;
    name = "Langston Barrett";
  };
  siers = {
    email = "veinbahs+nixpkgs@gmail.com";
    github = "siers";
    githubId = 235147;
    name = "Raitis Veinbahs";
  };
  sifmelcara = {
    email = "ming@culpring.com";
    github = "sifmelcara";
    githubId = 10496191;
    name = "Ming Chuan";
  };
  sigma = {
    email = "yann.hodique@gmail.com";
    github = "sigma";
    githubId = 16090;
    name = "Yann Hodique";
  };
  sikmir = {
    email = "sikmir@disroot.org";
    github = "sikmir";
    githubId = 688044;
    name = "Nikolay Korotkiy";
    keys = [{
      longkeyid = "rsa2048/0xD1DE6D7F693663A5";
      fingerprint = "ADF4 C13D 0E36 1240 BD01  9B51 D1DE 6D7F 6936 63A5";
    }];
  };
  simarra = {
    name = "simarra";
    email = "loic.martel@protonmail.com";
    github = "simarra";
    githubId = 14372987;
  };
  simonchatts = {
    email = "code@chatts.net";
    github = "simonchatts";
    githubId = 11135311;
    name = "Simon Chatterjee";
  };
  simonkampe = {
    email = "simon.kampe+nix@gmail.com";
    github = "simonkampe";
    githubId = 254799;
    name = "Simon Kämpe";
  };
  simonvandel = {
    email = "simon.vandel@gmail.com";
    github = "simonvandel";
    githubId = 2770647;
    name = "Simon Vandel Sillesen";
  };
  siraben = {
    email = "bensiraphob@gmail.com";
    matrix = "@siraben:matrix.org";
    github = "siraben";
    githubId = 8219659;
    name = "Siraphob Phipathananunth";
  };
  siriobalmelli = {
    email = "sirio@b-ad.ch";
    github = "siriobalmelli";
    githubId = 23038812;
    name = "Sirio Balmelli";
    keys = [{
      longkeyid = "ed25519/0xF72C4A887F9A24CA";
      fingerprint = "B234 EFD4 2B42 FE81 EE4D  7627 F72C 4A88 7F9A 24CA";
    }];
  };
  sirseruju = {
    email = "sir.seruju@yandex.ru";
    github = "sirseruju";
    githubId = 74881555;
    name = "Fofanov Sergey";
  };
  sivteck = {
    email = "sivaram1992@gmail.com";
    github = "sivteck";
    githubId = 8017899;
    name = "Sivaram Balakrishnan";
  };
  sjagoe = {
    email = "simon@simonjagoe.com";
    github = "sjagoe";
    githubId = 80012;
    name = "Simon Jagoe";
  };
  sjau = {
    email = "nixos@sjau.ch";
    github = "sjau";
    githubId = 848812;
    name = "Stephan Jau";
  };
  sjfloat = {
    email = "steve+nixpkgs@jonescape.com";
    github = "sjfloat";
    githubId = 216167;
    name = "Steve Jones";
  };
  sjmackenzie = {
    email = "setori88@gmail.com";
    github = "sjmackenzie";
    githubId = 158321;
    name = "Stewart Mackenzie";
  };
  sjourdois = {
    email = "sjourdois@gmail.com";
    name = "Stéphane ‘kwisatz’ Jourdois";
  };
  skeidel = {
    email = "svenkeidel@gmail.com";
    github = "svenkeidel";
    githubId = 266500;
    name = "Sven Keidel";
  };
  skrzyp = {
    email = "jot.skrzyp@gmail.com";
    name = "Jakub Skrzypnik";
  };
  skykanin = {
    email = "skykanin@users.noreply.github.com";
    github = "skykanin";
    githubId = 3789764;
    name = "skykanin";
  };
  sleexyz = {
    email = "freshdried@gmail.com";
    github = "sleexyz";
    githubId = 1505617;
    name = "Sean Lee";
  };
  SlothOfAnarchy = {
    email = "slothofanarchy1@gmail.com";
    matrix = "@michel.weitbrecht:helsinki-systems.de";
    github = "SlothOfAnarchy";
    githubId = 12828415;
    name = "Michel Weitbrecht";
  };
  smakarov = {
    email = "setser200018@gmail.com";
    github = "setser";
    githubId = 12733495;
    name = "Sergey Makarov";
    keys = [{
      longkeyid = "rsa2048/6AA23A1193B7064B";
      fingerprint = "6F8A 18AE 4101 103F 3C54  24B9 6AA2 3A11 93B7 064B";
    }];
  };
  smancill = {
    email = "smancill@smancill.dev";
    github = "smancill";
    githubId = 238528;
    name = "Sebastián Mancilla";
  };
  smaret = {
    email = "sebastien.maret@icloud.com";
    github = "smaret";
    githubId = 95471;
    name = "Sébastien Maret";
    keys = [{
      longkeyid = "rsa4096/0x86E30E5A0F5FC59C";
      fingerprint = "4242 834C D401 86EF 8281  4093 86E3 0E5A 0F5F C59C";
    }];
  };
  smasher164 = {
    email = "aindurti@gmail.com";
    github = "smasher164";
    githubId = 12636891;
    name = "Akhil Indurti";
  };
  smironov = {
    email = "grrwlf@gmail.com";
    github = "grwlf";
    githubId = 4477729;
    name = "Sergey Mironov";
  };
  smitop = {
    name = "Smitty van Bodegom";
    email = "me@smitop.com";
    matrix = "@smitop:kde.org";
    github = "Smittyvb";
    githubId = 10530973;
  };
  sna = {
    email = "abouzahra.9@wright.edu";
    github = "s-na";
    githubId = 20214715;
    name = "S. Nordin Abouzahra";
  };
  snaar = {
    email = "snaar@snaar.net";
    github = "snaar";
    githubId = 602439;
    name = "Serguei Narojnyi";
  };
  snicket2100 = {
    email = "57048005+snicket2100@users.noreply.github.com";
    github = "snicket2100";
    githubId = 57048005;
    name = "snicket2100";
  };
  snyh = {
    email = "snyh@snyh.org";
    github = "snyh";
    githubId = 1437166;
    name = "Xia Bin";
  };
  softinio = {
    email = "code@softinio.com";
    github = "softinio";
    githubId = 3371635;
    name = "Salar Rahmanian";
  };
  sohalt = {
    email = "nixos@sohalt.net";
    github = "sohalt";
    githubId = 2157287;
    name = "sohalt";
  };
  solson = {
    email = "scott@solson.me";
    matrix = "@solson:matrix.org";
    github = "solson";
    githubId = 26806;
    name = "Scott Olson";
  };
  SomeoneSerge = {
    email = "sergei.kozlukov@aalto.fi";
    matrix = "@ss:someonex.net";
    github = "SomeoneSerge";
    githubId = 9720532;
    name = "Sergei K";
  };
  sondr3 = {
    email = "nilsen.sondre@gmail.com";
    github = "sondr3";
    githubId = 2280539;
    name = "Sondre Nilsen";
    keys = [{
      longkeyid = "ed25519/0x25676BCBFFAD76B1";
      fingerprint = "0EC3 FA89 EFBA B421 F82E  40B0 2567 6BCB FFAD 76B1";
    }];
  };
  sophrosyne = {
    email = "joshuaortiz@tutanota.com";
    github = "sophrosyne97";
    githubId = 53029739;
    name = "Joshua Ortiz";
  };
  sorki = {
    email = "srk@48.io";
    github = "sorki";
    githubId = 115308;
    name = "Richard Marko";
  };
  sorpaas = {
    email = "hi@that.world";
    github = "sorpaas";
    githubId = 6277322;
    name = "Wei Tang";
  };
  spacefrogg = {
    email = "spacefrogg-nixos@meterriblecrew.net";
    github = "spacefrogg";
    githubId = 167881;
    name = "Michael Raitza";
  };
  spacekookie = {
    email = "kookie@spacekookie.de";
    github = "spacekookie";
    githubId = 7669898;
    name = "Katharina Fey";
  };
  spease = {
    email = "peasteven@gmail.com";
    github = "spease";
    githubId = 2825204;
    name = "Steven Pease";
  };
  spencerjanssen = {
    email = "spencerjanssen@gmail.com";
    matrix = "@sjanssen:matrix.org";
    github = "spencerjanssen";
    githubId = 2600039;
    name = "Spencer Janssen";
  };
  spinus = {
    email = "tomasz.czyz@gmail.com";
    github = "spinus";
    githubId = 950799;
    name = "Tomasz Czyż";
  };
  sprock = {
    email = "rmason@mun.ca";
    github = "sprock";
    githubId = 6391601;
    name = "Roger Mason";
  };
  spwhitt = {
    email = "sw@swhitt.me";
    github = "spwhitt";
    githubId = 1414088;
    name = "Spencer Whitt";
  };
  squalus = {
    email = "squalus@tuta.io";
    github = "squalus";
    githubId = 36899624;
    name = "squalus";
  };
  srapenne = {
    email = "solene@perso.pw";
    github = "rapenne-s";
    githubId = 248016;
    name = "Solène Rapenne";
  };
  srghma = {
    email = "srghma@gmail.com";
    github = "srghma";
    githubId = 7573215;
    name = "Sergei Khoma";
  };
  srgom = {
    email = "srgom@users.noreply.github.com";
    github = "srgom";
    githubId = 8103619;
    name = "SRGOM";
  };
  srhb = {
    email = "sbrofeldt@gmail.com";
    matrix = "@srhb:matrix.org";
    github = "srhb";
    githubId = 219362;
    name = "Sarah Brofeldt";
  };
  SShrike = {
    email = "severen@shrike.me";
    github = "severen";
    githubId = 4061736;
    name = "Severen Redwood";
  };
  sstef = {
    email = "stephane@nix.frozenid.net";
    github = "fkstef";
    githubId = 8668915;
    name = "Stephane Schitter";
  };
  staccato = {
    name = "staccato";
    email = "moveq@riseup.net";
    github = "staccato";
    githubId = 86573128;
  };
  stackshadow = {
    email = "stackshadow@evilbrain.de";
    github = "stackshadow";
    githubId = 7512804;
    name = "Martin Langlotz";
  };
  steamwalker = {
    email = "steamwalker@xs4all.nl";
    github = "steamwalker";
    githubId = 94006354;
    name = "steamwalker";
  };
  steell = {
    email = "steve@steellworks.com";
    github = "Steell";
    githubId = 1699155;
    name = "Steve Elliott";
  };
  stelcodes = {
    email = "stel@stel.codes";
    github = "stelcodes";
    githubId = 22163194;
    name = "Stel Abrego";
  };
  stephank = {
    email = "nix@stephank.nl";
    matrix = "@skochen:matrix.org";
    github = "stephank";
    githubId = 89950;
    name = "Stéphan Kochen";
  };
  stephenmw = {
    email = "stephen@q5comm.com";
    github = "stephenmw";
    githubId = 231788;
    name = "Stephen Weinberg";
  };
  stephenwithph = {
    name = "StephenWithPH";
    email = "StephenWithPH@users.noreply.github.com";
    github = "StephenWithPH";
    githubId = 2990492;
  };
  sterfield = {
    email = "sterfield@gmail.com";
    github = "sterfield";
    githubId = 5747061;
    name = "Guillaume Loetscher";
  };
  sternenseemann = {
    email = "sternenseemann@systemli.org";
    github = "sternenseemann";
    githubId = 3154475;
    name = "Lukas Epple";
  };
  steshaw = {
    name = "Steven Shaw";
    email = "steven@steshaw.org";
    github = "steshaw";
    githubId = 45735;
    keys = [{
      longkeyid = "rsa4096/0x1D9A17DFD23DCB91";
      fingerprint = "0AFE 77F7 474D 1596 EE55  7A29 1D9A 17DF D23D CB91";
    }];
  };
  stesie = {
    email = "stesie@brokenpipe.de";
    github = "stesie";
    githubId = 113068;
    name = "Stefan Siegl";
  };
  steve-chavez = {
    email = "stevechavezast@gmail.com";
    github = "steve-chavez";
    githubId = 1829294;
    name = "Steve Chávez";
  };
  stevebob = {
    email = "stephen@sherra.tt";
    github = "stevebob";
    githubId = 417118;
    name = "Stephen Sherratt";
  };
  steveej = {
    email = "mail@stefanjunker.de";
    github = "steveej";
    githubId = 1181362;
    name = "Stefan Junker";
  };
  stevenroose = {
    email = "github@stevenroose.org";
    github = "stevenroose";
    githubId = 853468;
    name = "Steven Roose";
  };
  stianlagstad = {
    email = "stianlagstad@gmail.com";
    github = "stianlagstad";
    githubId = 4340859;
    name = "Stian Lågstad";
  };
  StijnDW = {
    email = "nixdev@rinsa.eu";
    github = "Stekke";
    githubId = 1751956;
    name = "Stijn DW";
  };
  StillerHarpo = {
    email = "florianengel39@gmail.com";
    github = "StillerHarpo";
    githubId = 25526706;
    name = "Florian Engel";
  };
  stites = {
    email = "sam@stites.io";
    github = "stites";
    githubId = 1694705;
    name = "Sam Stites";
  };
  stumoss = {
    email = "samoss@gmail.com";
    github = "stumoss";
    githubId = 638763;
    name = "Stuart Moss";
  };
  stunkymonkey = {
    email = "account@buehler.rocks";
    github = "Stunkymonkey";
    githubId = 1315818;
    name = "Felix Bühler";
  };
  stupremee = {
    email = "jutus.k@protonmail.com";
    github = "Stupremee";
    githubId = 39732259;
    name = "Justus K";
  };
  SubhrajyotiSen = {
    email = "subhrajyoti12@gmail.com";
    github = "SubhrajyotiSen";
    githubId = 12984845;
    name = "Subhrajyoti Sen";
  };
  suhr = {
    email = "suhr@i2pmail.org";
    github = "suhr";
    githubId = 65870;
    name = "Сухарик";
  };
  sumnerevans = {
    email = "me@sumnerevans.com";
    github = "sumnerevans";
    githubId = 16734772;
    name = "Sumner Evans";
  };
  superbo = {
    email = "supernbo@gmail.com";
    github = "SuperBo";
    githubId = 2666479;
    name = "Y Nguyen";
  };
  superherointj = {
    name = "Sérgio G.";
    email = "5861043+superherointj@users.noreply.github.com";
    matrix = "@superherointj:matrix.org";
    github = "superherointj";
    githubId = 5861043;
  };
  SuperSandro2000 = {
    email = "sandro.jaeckel@gmail.com";
    matrix = "@sandro:supersandro.de";
    github = "SuperSandro2000";
    githubId = 7258858;
    name = "Sandro Jäckel";
  };
  SuprDewd = {
    email = "suprdewd@gmail.com";
    github = "SuprDewd";
    githubId = 187109;
    name = "Bjarki Ágúst Guðmundsson";
  };
  suryasr007 = {
    email = "94suryateja@gmail.com";
    github = "suryasr007";
    githubId = 10533926;
    name = "Surya Teja V";
  };
  suvash = {
    email = "suvash+nixpkgs@gmail.com";
    github = "suvash";
    githubId = 144952;
    name = "Suvash Thapaliya";
  };
  sveitser = {
    email = "sveitser@gmail.com";
    github = "sveitser";
    githubId = 1040871;
    name = "Mathis Antony";
  };
  svend = {
    email = "svend@svends.net";
    github = "svend";
    githubId = 306190;
    name = "Svend Sorensen";
  };
  svrana = {
    email = "shaw@vranix.com";
    github = "svrana";
    githubId = 850665;
    name = "Shaw Vrana";
  };
  svsdep = {
    email = "svsdep@gmail.com";
    github = "svsdep";
    githubId = 36695359;
    name = "Vasyl Solovei";
  };
  swarren83 = {
    email = "shawn.w.warren@gmail.com";
    github = "swarren83";
    githubId = 4572854;
    name = "Shawn Warren";
  };
  swdunlop = {
    email = "swdunlop@gmail.com";
    github = "swdunlop";
    githubId = 120188;
    name = "Scott W. Dunlop";
  };
  sweber = {
    email = "sweber2342+nixpkgs@gmail.com";
    github = "sweber83";
    githubId = 19905904;
    name = "Simon Weber";
  };
  swflint = {
    email = "swflint@flintfam.org";
    github = "swflint";
    githubId = 1771109;
    name = "Samuel W. Flint";
  };
  swistak35 = {
    email = "me@swistak35.com";
    github = "swistak35";
    githubId = 332289;
    name = "Rafał Łasocha";
  };
  syberant = {
    email = "sybrand@neuralcoding.com";
    github = "syberant";
    githubId = 20063502;
    name = "Sybrand Aarnoutse";
  };
  symphorien = {
    email = "symphorien_nixpkgs@xlumurb.eu";
    matrix = "@symphorien:xlumurb.eu";
    github = "symphorien";
    githubId = 12595971;
    name = "Guillaume Girol";
  };
  synthetica = {
    email = "nix@hilhorst.be";
    github = "Synthetica9";
    githubId = 7075751;
    name = "Patrick Hilhorst";
  };
  szczyp = {
    email = "qb@szczyp.com";
    github = "szczyp";
    githubId = 203195;
    name = "Szczyp";
  };
  szlend = {
    email = "pub.nix@zlender.si";
    github = "szlend";
    githubId = 7301807;
    name = "Simon Žlender";
  };
  sztupi = {
    email = "attila.sztupak@gmail.com";
    github = "sztupi";
    githubId = 143103;
    name = "Attila Sztupak";
  };
  t184256 = {
    email = "monk@unboiled.info";
    github = "t184256";
    githubId = 5991987;
    name = "Alexander Sosedkin";
  };
  tadeokondrak = {
    email = "me@tadeo.ca";
    github = "tadeokondrak";
    githubId = 4098453;
    name = "Tadeo Kondrak";
    keys = [{
      longkeyid = "ed25519/0xFBE607FCC49516D3";
      fingerprint = "0F2B C0C7 E77C 5B42 AC5B  4C18 FBE6 07FC C495 16D3";
    }];
  };
  tadfisher = {
    email = "tadfisher@gmail.com";
    github = "tadfisher";
    githubId = 129148;
    name = "Tad Fisher";
  };
  taeer = {
    email = "taeer@necsi.edu";
    github = "Radvendii";
    githubId = 1239929;
    name = "Taeer Bar-Yam";
  };
  taha = {
    email = "xrcrod@gmail.com";
    github = "tgharib";
    githubId = 6457015;
    name = "Taha Gharib";
  };
  tailhook = {
    email = "paul@colomiets.name";
    github = "tailhook";
    githubId = 321799;
    name = "Paul Colomiets";
  };
  taikx4 = {
    email = "taikx4@taikx4szlaj2rsdupcwabg35inbny4jk322ngeb7qwbbhd5i55nf5yyd.onion";
    github = "taikx4";
    githubId = 94917129;
    name = "taikx4";
    keys = [{
      longkeyid = "ed25519/0xCCD52C7B37BB837E";
      fingerprint = "6B02 8103 C4E5 F68C D77C  9E54 CCD5 2C7B 37BB 837E";
    }];
  };
  takagiy = {
    email = "takagiy.4dev@gmail.com";
    github = "takagiy";
    githubId = 18656090;
    name = "Yuki Takagi";
  };
  taketwo = {
    email = "alexandrov88@gmail.com";
    github = "taketwo";
    githubId = 1241736;
    name = "Sergey Alexandrov";
  };
  takikawa = {
    email = "asumu@igalia.com";
    github = "takikawa";
    githubId = 64192;
    name = "Asumu Takikawa";
  };
  taktoa = {
    email = "taktoa@gmail.com";
    matrix = "@taktoa:matrix.org";
    github = "taktoa";
    githubId = 553443;
    name = "Remy Goldschmidt";
  };
  taku0 = {
    email = "mxxouy6x3m_github@tatapa.org";
    github = "taku0";
    githubId = 870673;
    name = "Takuo Yonezawa";
  };
  talkara = {
    email = "taito.horiuchi@relexsolutions.com";
    github = "talkara";
    githubId = 51232929;
    name = "Taito Horiuchi";
  };
  talyz = {
    email = "kim.lindberger@gmail.com";
    matrix = "@talyz:matrix.org";
    github = "talyz";
    githubId = 63433;
    name = "Kim Lindberger";
  };
  taneb = {
    email = "nvd1234@gmail.com";
    github = "Taneb";
    githubId = 1901799;
    name = "Nathan van Doorn";
  };
  tari = {
    email = "peter@taricorp.net";
    github = "tari";
    githubId = 506181;
    name = "Peter Marheine";
  };
  tasmo = {
    email = "tasmo@tasmo.de";
    github = "tasmo";
    githubId = 102685;
    name = "Thomas Friese";
  };
  tazjin = {
    email = "mail@tazj.in";
    github = "tazjin";
    githubId = 1552853;
    name = "Vincent Ambo";
  };
  tbenst = {
    email = "nix@tylerbenster.com";
    github = "tbenst";
    githubId = 863327;
    name = "Tyler Benster";
  };
  tboerger = {
    email = "thomas@webhippie.de";
    matrix = "@tboerger:matrix.org";
    github = "tboerger";
    githubId = 156964;
    name = "Thomas Boerger";
  };
  tcbravo = {
    email = "tomas.bravo@protonmail.ch";
    github = "tcbravo";
    githubId = 66133083;
    name = "Tomas Bravo";
  };
  tckmn = {
    email = "andy@tck.mn";
    github = "tckmn";
    githubId = 2389333;
    name = "Andy Tockman";
  };
  techknowlogick = {
    email = "techknowlogick@gitea.io";
    github = "techknowlogick";
    githubId = 164197;
    name = "techknowlogick";
  };
  Technical27 = {
    email = "38222826+Technical27@users.noreply.github.com";
    github = "Technical27";
    githubId = 38222826;
    name = "Aamaruvi Yogamani";
  };
  teh = {
    email = "tehunger@gmail.com";
    github = "teh";
    githubId = 139251;
    name = "Tom Hunger";
  };
  telotortium = {
    email = "rirelan@gmail.com";
    github = "telotortium";
    githubId = 1755789;
    name = "Robert Irelan";
  };
  teozkr = {
    email = "teo@nullable.se";
    github = "teozkr";
    githubId = 649832;
    name = "Teo Klestrup Röijezon";
  };
  terin = {
    email = "terinjokes@gmail.com";
    github = "terinjokes";
    githubId = 273509;
    name = "Terin Stock";
  };
  terlar = {
    email = "terlar@gmail.com";
    github = "terlar";
    githubId = 280235;
    name = "Terje Larsen";
  };
  terrorjack = {
    email = "astrohavoc@gmail.com";
    github = "TerrorJack";
    githubId = 3889585;
    name = "Cheng Shao";
  };
  tesq0 = {
    email = "mikolaj.galkowski@gmail.com";
    github = "tesq0";
    githubId = 26417242;
    name = "Mikolaj Galkowski";
  };
  TethysSvensson = {
    email = "freaken@freaken.dk";
    github = "TethysSvensson";
    githubId = 4294434;
    name = "Tethys Svensson";
  };
  teto = {
    email = "mcoudron@hotmail.com";
    github = "teto";
    githubId = 886074;
    name = "Matthieu Coudron";
  };
  tex = {
    email = "milan.svoboda@centrum.cz";
    github = "tex";
    githubId = 27386;
    name = "Milan Svoboda";
  };
  tfc = {
    email = "jacek@galowicz.de";
    matrix = "@jonge:ukvly.org";
    github = "tfc";
    githubId = 29044;
    name = "Jacek Galowicz";
  };
  tg-x = {
    email = "*@tg-x.net";
    github = "tg-x";
    githubId = 378734;
    name = "TG ⊗ Θ";
  };
  tgunnoe = {
    email = "t@gvno.net";
    github = "tgunnoe";
    githubId = 7254833;
    name = "Taylor Gunnoe";
  };
  th0rgal = {
    email = "thomas.marchand@tuta.io";
    github = "Th0rgal";
    githubId = 41830259;
    name = "Thomas Marchand";
  };
  thall = {
    email = "niclas.thall@gmail.com";
    github = "thall";
    githubId = 102452;
    name = "Niclas Thall";
  };
  thammers = {
    email = "jawr@gmx.de";
    github = "tobias-hammerschmidt";
    githubId = 2543259;
    name = "Tobias Hammerschmidt";
  };
  thanegill = {
    email = "me@thanegill.com";
    github = "thanegill";
    githubId = 1141680;
    name = "Thane Gill";
  };
  thblt = {
    name = "Thibault Polge";
    email = "thibault@thb.lt";
    matrix = "@thbltp:matrix.org";
    github = "thblt";
    githubId = 2453136;
    keys = [{
      longkeyid = "rsa4096/0x63A44817A52EAB7B";
      fingerprint = "D2A2 F0A1 E7A8 5E6F B711  DEE5 63A4 4817 A52E AB7B";
    }];
  };
  TheBrainScrambler = {
    email = "esthromeris@riseup.net";
    github = "TheBrainScrambler";
    githubId = 34945377;
    name = "John Smith";
  };
  thedavidmeister = {
    email = "thedavidmeister@gmail.com";
    github = "thedavidmeister";
    githubId = 629710;
    name = "David Meister";
  };
  thefloweringash = {
    email = "lorne@cons.org.nz";
    github = "thefloweringash";
    githubId = 42933;
    name = "Andrew Childs";
  };
  thefenriswolf = {
    email = "stefan.rohrbacher97@gmail.com";
    github = "thefenriswolf";
    githubId = 8547242;
    name = "Stefan Rohrbacher";
  };
  thelegy = {
    email = "mail+nixos@0jb.de";
    github = "thelegy";
    githubId = 3105057;
    name = "Jan Beinke";
  };
  therealansh = {
    email = "tyagiansh23@gmail.com";
    github = "therealansh";
    githubId = 57180880;
    name = "Ansh Tyagi";
  };
  thesola10 = {
    email = "me@thesola.io";
    github = "thesola10";
    githubId = 7287268;
    keys = [{
      longkeyid = "rsa4096/0x89245619BEBB95BA";
      fingerprint = "1D05 13A6 1AC4 0D8D C6D6  5F2C 8924 5619 BEBB 95BA";
    }];
    name = "Karim Vergnes";
  };
  theuni = {
    email = "ct@flyingcircus.io";
    github = "ctheune";
    githubId = 1220572;
    name = "Christian Theune";
  };
  thiagokokada = {
    email = "thiagokokada@gmail.com";
    github = "thiagokokada";
    githubId = 844343;
    name = "Thiago K. Okada";
  };
  thibautmarty = {
    email = "github@thibautmarty.fr";
    matrix = "@thibaut:thibautmarty.fr";
    github = "ThibautMarty";
    githubId = 3268082;
    name = "Thibaut Marty";
  };
  thmzlt = {
    email = "git@thomazleite.com";
    github = "thmzlt";
    githubId = 7709;
    name = "Thomaz Leite";
  };
  thomasdesr = {
    email = "git@hive.pw";
    github = "thomasdesr";
    githubId = 681004;
    name = "Thomas Desrosiers";
  };
  ThomasMader = {
    email = "thomas.mader@gmail.com";
    github = "ThomasMader";
    githubId = 678511;
    name = "Thomas Mader";
  };
  thomasjm = {
    email = "tom@codedown.io";
    github = "thomasjm";
    githubId = 1634990;
    name = "Tom McLaughlin";
  };
  thoughtpolice = {
    email = "aseipp@pobox.com";
    github = "thoughtpolice";
    githubId = 3416;
    name = "Austin Seipp";
  };
  thpham = {
    email = "thomas.pham@ithings.ch";
    github = "thpham";
    githubId = 224674;
    name = "Thomas Pham";
  };
  Thra11 = {
    email = "tahall256@protonmail.ch";
    github = "Thra11";
    githubId = 1391883;
    name = "Tom Hall";
  };
  Thunderbottom = {
    email = "chinmaydpai@gmail.com";
    github = "Thunderbottom";
    githubId = 11243138;
    name = "Chinmay D. Pai";
    keys = [{
      longkeyid = "rsa4096/0x75507BE256F40CED";
      fingerprint = "7F3E EEAA EE66 93CC 8782  042A 7550 7BE2 56F4 0CED";
    }];
  };
  tiagolobocastro = {
    email = "tiagolobocastro@gmail.com";
    github = "tiagolobocastro";
    githubId = 1618946;
    name = "Tiago Castro";
  };
  tilcreator = {
    name = "TilCreator";
    email = "contact.nixos@tc-j.de";
    matrix = "@tilcreator:matrix.org";
    github = "TilCreator";
    githubId = 18621411;
  };
  tilpner = {
    email = "till@hoeppner.ws";
    github = "tilpner";
    githubId = 4322055;
    name = "Till Höppner";
  };
  timbertson = {
    email = "tim@gfxmonk.net";
    github = "timbertson";
    githubId = 14172;
    name = "Tim Cuthbertson";
  };
  timma = {
    email = "kunduru.it.iitb@gmail.com";
    github = "ktrsoft";
    githubId = 12712927;
    name = "Timma";
  };
  timokau = {
    email = "timokau@zoho.com";
    github = "timokau";
    githubId = 3799330;
    name = "Timo Kaufmann";
  };
  timor = {
    email = "timor.dd@googlemail.com";
    github = "timor";
    githubId = 174156;
    name = "timor";
  };
  timput = {
    email = "tim@timput.com";
    github = "TimPut";
    githubId = 2845239;
    name = "Tim Put";
  };
  timstott = {
    email = "stott.timothy@gmail.com";
    github = "timstott";
    githubId = 1334474;
    name = "Timothy Stott";
  };
  tiramiseb = {
    email = "sebastien@maccagnoni.eu";
    github = "tiramiseb";
    githubId = 1292007;
    name = "Sébastien Maccagnoni";
  };
  titanous = {
    email = "jonathan@titanous.com";
    github = "titanous";
    githubId = 13026;
    name = "Jonathan Rudenberg";
  };
  tkerber = {
    email = "tk@drwx.org";
    github = "tkerber";
    githubId = 5722198;
    name = "Thomas Kerber";
    keys = [{
      longkeyid = "rsa4096/0x8489B911F9ED617B";
      fingerprint = "556A 403F B0A2 D423 F656  3424 8489 B911 F9ED 617B";
    }];
  };
  tmarkovski = {
    email = "tmarkovski@gmail.com";
    github = "tmarkovski";
    githubId = 1280118;
    name = "Tomislav Markovski";
  };
  tmountain = {
    email = "tinymountain@gmail.com";
    github = "tmountain";
    githubId = 135297;
    name = "Travis Whitton";
  };
  tmplt = {
    email = "tmplt@dragons.rocks";
    github = "tmplt";
    githubId = 6118602;
    name = "Viktor";
  };
  tnias = {
    email = "phil@grmr.de";
    matrix = "@tnias:stratum0.org";
    github = "tnias";
    githubId = 9853194;
    name = "Philipp Bartsch";
  };
  toastal = {
    email = "toastal+nix@posteo.net";
    matrix = "@toastal:matrix.org";
    github = "toastal";
    githubId = 561087;
    name = "toastal";
    keys = [{
      longkeyid = "ed25519/5CCE6F1466D47C9E";
      fingerprint = "7944 74B7 D236 DAB9 C9EF  E7F9 5CCE 6F14 66D4 7C9E";
    }];
  };
  tobim = {
    email = "nix@tobim.fastmail.fm";
    github = "tobim";
    githubId = 858790;
    name = "Tobias Mayer";
  };
  tobiasBora = {
    email = "tobias.bora.list@gmail.com";
    github = "tobiasBora";
    githubId = 2164118;
    name = "Tobias Bora";
  };
  tohl = {
    email = "tom@logand.com";
    github = "tohl";
    githubId = 12159013;
    name = "Tomas Hlavaty";
  };
  tokudan = {
    email = "git@danielfrank.net";
    github = "tokudan";
    githubId = 692610;
    name = "Daniel Frank";
  };
  tomahna = {
    email = "kevin.rauscher@tomahna.fr";
    github = "Tomahna";
    githubId = 8577941;
    name = "Kevin Rauscher";
  };
  tomberek = {
    email = "tomberek@gmail.com";
    matrix = "@tomberek:matrix.org";
    github = "tomberek";
    githubId = 178444;
    name = "Thomas Bereknyei";
  };
  tomfitzhenry = {
    email = "tom@tom-fitzhenry.me.uk";
    github = "tomfitzhenry";
    githubId = 61303;
    name = "Tom Fitzhenry";
  };
  tomsmeets = {
    email = "tom.tsmeets@gmail.com";
    github = "tomsmeets";
    githubId = 6740669;
    name = "Tom Smeets";
  };
  toonn = {
    email = "nixpkgs@toonn.io";
    matrix = "@toonn:matrix.org";
    github = "toonn";
    githubId = 1486805;
    name = "Toon Nolten";
  };
  toschmidt = {
    email = "tobias.schmidt@in.tum.de";
    github = "toschmidt";
    githubId = 27586264;
    name = "Tobias Schmidt";
  };
  totoroot = {
    name = "Matthias Thym";
    email = "git@thym.at";
    github = "totoroot";
    githubId = 39650930;
  };
  ToxicFrog = {
    email = "toxicfrog@ancilla.ca";
    github = "ToxicFrog";
    githubId = 90456;
    name = "Rebecca (Bex) Kelly";
  };
  travisbhartwell = {
    email = "nafai@travishartwell.net";
    github = "travisbhartwell";
    githubId = 10110;
    name = "Travis B. Hartwell";
  };
  travisdavis-ops = {
    email = "travisdavismedia@gmail.com";
    github = "travisdavis-ops";
    githubId = 52011418;
    name = "Travis Davis";
  };
  TredwellGit = {
    email = "tredwell@tutanota.com";
    github = "TredwellGit";
    githubId = 61860346;
    name = "Tredwell";
  };
  treemo = {
    email = "matthieu.chevrier@treemo.fr";
    github = "treemo";
    githubId = 207457;
    name = "Matthieu Chevrier";
  };
  trepetti = {
    email = "trepetti@cs.columbia.edu";
    github = "trepetti";
    githubId = 25440339;
    name = "Tom Repetti";
  };
  trevorj = {
    email = "nix@trevor.joynson.io";
    github = "akatrevorjay";
    githubId = 1312290;
    name = "Trevor Joynson";
  };
  tricktron = {
    email = "tgagnaux@gmail.com";
    github = "tricktron";
    githubId = 16036882;
    name = "Thibault Gagnaux";
  };
  trino = {
    email = "muehlhans.hubert@ekodia.de";
    github = "hmuehlhans";
    githubId = 9870613;
    name = "Hubert Mühlhans";
  };
  troydm = {
    email = "d.geurkov@gmail.com";
    github = "troydm";
    githubId = 483735;
    name = "Dmitry Geurkov";
  };
  truh = {
    email = "jakob-nixos@truh.in";
    github = "truh";
    githubId = 1183303;
    name = "Jakob Klepp";
  };
  trundle = {
    name = "Andreas Stührk";
    email = "andy@hammerhartes.de";
    github = "Trundle";
    githubId = 332418;
  };
  tscholak = {
    email = "torsten.scholak@googlemail.com";
    github = "tscholak";
    githubId = 1568873;
    name = "Torsten Scholak";
  };
  tshaynik = {
    email = "tshaynik@protonmail.com";
    github = "tshaynik";
    githubId = 15064765;
    name = "tshaynik";
  };
  tstrobel = {
    email = "4ZKTUB6TEP74PYJOPWIR013S2AV29YUBW5F9ZH2F4D5UMJUJ6S@hash.domains";
    name = "Thomas Strobel";
  };
  ttuegel = {
    email = "ttuegel@mailbox.org";
    github = "ttuegel";
    githubId = 563054;
    name = "Thomas Tuegel";
  };
  turion = {
    email = "programming@manuelbaerenz.de";
    github = "turion";
    githubId = 303489;
    name = "Manuel Bärenz";
  };
  tu-maurice = {
    email = "valentin.gehrke+nixpkgs@zom.bi";
    github = "tu-maurice";
    githubId = 16151097;
    name = "Valentin Gehrke";
  };
  tuxinaut = {
    email = "trash4you@tuxinaut.de";
    github = "tuxinaut";
    githubId = 722482;
    name = "Denny Schäfer";
    keys = [{
      longkeyid = "rsa4096/0xB057455D1E567270";
      fingerprint = "C752 0E49 4D92 1740 D263  C467 B057 455D 1E56 7270";
    }];
  };
  tv = {
    email = "tv@krebsco.de";
    github = "4z3";
    githubId = 427872;
    name = "Tomislav Viljetić";
  };
  tvestelind = {
    email = "tomas.vestelind@fripost.org";
    github = "tvestelind";
    githubId = 699403;
    name = "Tomas Vestelind";
  };
  tviti = {
    email = "tviti@hawaii.edu";
    github = "tviti";
    githubId = 2251912;
    name = "Taylor Viti";
  };
  tvorog = {
    email = "marszaripov@gmail.com";
    github = "tvorog";
    githubId = 1325161;
    name = "Marsel Zaripov";
  };
  tweber = {
    email = "tw+nixpkgs@360vier.de";
    github = "thorstenweber83";
    githubId = 9413924;
    name = "Thorsten Weber";
  };
  twey = {
    email = "twey@twey.co.uk";
    github = "Twey";
    githubId = 101639;
    name = "James ‘Twey’ Kay";
  };
  twhitehead = {
    name = "Tyson Whitehead";
    email = "twhitehead@gmail.com";
    github = "twhitehead";
    githubId = 787843;
    keys = [{
      longkeyid = "rsa2048/0x594258F0389D2802";
      fingerprint = "E631 8869 586F 99B4 F6E6  D785 5942 58F0 389D 2802";
    }];
  };
  twitchyliquid64 = {
    name = "Tom";
    email = "twitchyliquid64@ciphersink.net";
    github = "twitchyliquid64";
    githubId = 6328589;
  };
  typetetris = {
    email = "ericwolf42@mail.com";
    github = "typetetris";
    githubId = 1983821;
    name = "Eric Wolf";
  };
  udono = {
    email = "udono@virtual-things.biz";
    github = "udono";
    githubId = 347983;
    name = "Udo Spallek";
  };
  ulrikstrid = {
    email = "ulrik.strid@outlook.com";
    github = "ulrikstrid";
    githubId = 1607770;
    name = "Ulrik Strid";
  };
  unclechu = {
    name = "Viacheslav Lotsmanov";
    email = "lotsmanov89@gmail.com";
    github = "unclechu";
    githubId = 799353;
    keys = [{
      longkeyid = "rsa4096/0xD276FF7467007335";
      fingerprint = "EE59 5E29 BB5B F2B3 5ED2  3F1C D276 FF74 6700 7335";
    }];
  };
  uniquepointer = {
    email = "uniquepointer@mailbox.org";
    matrix = "@uniquepointer:matrix.org";
    github = "uniquepointer";
    githubId = 71751817;
    name = "uniquepointer";
  };
  unode = {
    email = "alves.rjc@gmail.com";
    matrix = "@renato_alves:matrix.org";
    github = "unode";
    githubId = 122319;
    name = "Renato Alves";
  };
  unrooted = {
    name = "Konrad Klawikowski";
    email = "konrad.root.klawikowski@gmail.com";
    github = "unrooted";
    githubId = 30440603;
  };
  uralbash = {
    email = "root@uralbash.ru";
    github = "uralbash";
    githubId = 619015;
    name = "Svintsov Dmitry";
  };
  urbas = {
    email = "matej.urbas@gmail.com";
    github = "urbas";
    githubId = 771193;
    name = "Matej Urbas";
  };
  uri-canva = {
    email = "uri@canva.com";
    github = "uri-canva";
    githubId = 33242106;
    name = "Uri Baghin";
  };
  urlordjames = {
    email = "urlordjames@gmail.com";
    github = "urlordjames";
    githubId = 32751441;
    name = "urlordjames";
  };
  uskudnik = {
    email = "urban.skudnik@gmail.com";
    github = "uskudnik";
    githubId = 120451;
    name = "Urban Skudnik";
  };
  utdemir = {
    email = "me@utdemir.com";
    github = "utdemir";
    githubId = 928084;
    name = "Utku Demir";
  };
  uvnikita = {
    email = "uv.nikita@gmail.com";
    github = "uvNikita";
    githubId = 1084748;
    name = "Nikita Uvarov";
  };
  uwap = {
    email = "me@uwap.name";
    github = "uwap";
    githubId = 2212422;
    name = "uwap";
  };
  V = {
    name = "V";
    email = "v@anomalous.eu";
    github = "deviant";
    githubId = 68829907;
  };
  vaibhavsagar = {
    email = "vaibhavsagar@gmail.com";
    matrix = "@vaibhavsagar:matrix.org";
    github = "vaibhavsagar";
    githubId = 1525767;
    name = "Vaibhav Sagar";
  };
  valebes = {
    email = "valebes@gmail.com";
    github = "valebes";
    githubId = 10956211;
    name = "Valerio Besozzi";
  };
  valeriangalliat = {
    email = "val@codejam.info";
    github = "valeriangalliat";
    githubId = 3929133;
    name = "Valérian Galliat";
  };
  valodim = {
    email = "look@my.amazin.horse";
    matrix = "@Valodim:stratum0.org";
    github = "valodim";
    githubId = 27813;
    name = "Vincent Breitmoser";
  };
  vandenoever = {
    email = "jos@vandenoever.info";
    github = "vandenoever";
    githubId = 608417;
    name = "Jos van den Oever";
  };
  vanilla = {
    email = "osu_vanilla@126.com";
    github = "VergeDX";
    githubId = 25173827;
    name = "Vanilla";
    keys = [{
      longkeyid = "rsa4096/0x3750028ED04FA42E";
      fingerprint = "2649 340C C909 F821 D251  6714 3750 028E D04F A42E";
    }];
  };
  vanschelven = {
    email = "klaas@vanschelven.com";
    github = "vanschelven";
    githubId = 223833;
    name = "Klaas van Schelven";
  };
  vanzef = {
    email = "vanzef@gmail.com";
    github = "vanzef";
    githubId = 12428837;
    name = "Ivan Solyankin";
  };
  varunpatro = {
    email = "varun.kumar.patro@gmail.com";
    github = "varunpatro";
    githubId = 6943308;
    name = "Varun Patro";
  };
  vbgl = {
    email = "Vincent.Laporte@gmail.com";
    github = "vbgl";
    githubId = 2612464;
    name = "Vincent Laporte";
  };
  vbmithr = {
    email = "vb@luminar.eu.org";
    github = "vbmithr";
    githubId = 797581;
    name = "Vincent Bernardoff";
  };
  vcanadi = {
    email = "vito.canadi@gmail.com";
    github = "vcanadi";
    githubId = 8889722;
    name = "Vitomir Čanadi";
  };
  vcunat = {
    name = "Vladimír Čunát";
    # vcunat@gmail.com predominated in commits before 2019/03
    email = "v@cunat.cz";
    matrix = "@vcunat:matrix.org";
    github = "vcunat";
    githubId = 1785925;
    keys = [{
      longkeyid = "rsa4096/0xE747DF1F9575A3AA";
      fingerprint = "B600 6460 B60A 80E7 8206  2449 E747 DF1F 9575 A3AA";
    }];
  };
  vdemeester = {
    email = "vincent@sbr.pm";
    github = "vdemeester";
    githubId = 6508;
    name = "Vincent Demeester";
  };
  veehaitch = {
    name = "Vincent Haupert";
    email = "mail@vincent-haupert.de";
    github = "veehaitch";
    githubId = 15069839;
    keys = [{
      longkeyid = "rsa4096/0x874BD6F916FAA742";
      fingerprint = "4D23 ECDF 880D CADF 5ECA  4458 874B D6F9 16FA A742";
    }];
  };
  vel = {
    email = "llathasa@outlook.com";
    github = "q60";
    githubId = 61933599;
    name = "vel";
  };
  velovix = {
    email = "xaviosx@gmail.com";
    github = "velovix";
    githubId = 2856634;
    name = "Tyler Compton";
  };
  veprbl = {
    email = "veprbl@gmail.com";
    github = "veprbl";
    githubId = 245573;
    name = "Dmitry Kalinkin";
  };
  vidbina = {
    email = "vid@bina.me";
    github = "vidbina";
    githubId = 335406;
    name = "David Asabina";
  };
  vidister = {
    email = "v@vidister.de";
    github = "vidister";
    githubId = 11413574;
    name = "Fiona Weber";
  };
  vifino = {
    email = "vifino@tty.sh";
    github = "vifino";
    githubId = 5837359;
    name = "Adrian Pistol";
  };
  vika_nezrimaya = {
    email = "vika@fireburn.ru";
    github = "kisik21";
    githubId = 7953163;
    name = "Vika Shleina";
    keys = [{
      longkeyid = "rsa2048/0x4F62CD07CE64796A";
      fingerprint = "B3C0 DA1A C18B 82E8 CA8B  B1D1 4F62 CD07 CE64 796A";
    }];
  };
  vincentbernat = {
    email = "vincent@bernat.ch";
    github = "vincentbernat";
    githubId = 631446;
    name = "Vincent Bernat";
    keys = [{
      longkeyid = "rsa4096/0x95A42FE8353525F9";
      fingerprint = "AEF2 3487 66F3 71C6 89A7  3600 95A4 2FE8 3535 25F9";
    }];
  };
  vinymeuh = {
    email = "vinymeuh@gmail.com";
    github = "vinymeuh";
    githubId = 118959;
    name = "VinyMeuh";
  };
  viric = {
    email = "viric@viric.name";
    github = "viric";
    githubId = 66664;
    name = "Lluís Batlle i Rossell";
  };
  virusdave = {
    email = "dave.nicponski@gmail.com";
    github = "virusdave";
    githubId = 6148271;
    name = "Dave Nicponski";
  };
  vizanto = {
    email = "danny@prime.vc";
    github = "vizanto";
    githubId = 326263;
    name = "Danny Wilson";
  };
  vklquevs = {
    email = "vklquevs@gmail.com";
    github = "vklquevs";
    githubId = 1771234;
    name = "vklquevs";
  };
  vlaci = {
    email = "laszlo.vasko@outlook.com";
    github = "vlaci";
    githubId = 1771332;
    name = "László Vaskó";
  };
  vlstill = {
    email = "xstill@fi.muni.cz";
    github = "vlstill";
    githubId = 4070422;
    name = "Vladimír Štill";
  };
  vmandela = {
    email = "venkat.mandela@gmail.com";
    github = "vmandela";
    githubId = 849772;
    name = "Venkateswara Rao Mandela";
  };
  vmchale = {
    email = "tmchale@wisc.edu";
    github = "vmchale";
    githubId = 13259982;
    name = "Vanessa McHale";
  };

  voidless = {
    email = "julius.schmitt@yahoo.de";
    github = "voidIess";
    githubId = 45292658;
    name = "Julius Schmitt";
  };
  vojta001 = {
    email = "vojtech.kane@gmail.com";
    github = "vojta001";
    githubId = 7038383;
    name = "Vojta Káně";
  };
  volhovm = {
    email = "volhovm.cs@gmail.com";
    github = "volhovm";
    githubId = 5604643;
    name = "Mikhail Volkhov";
  };
  volth = {
    email = "jaroslavas@volth.com";
    github = "volth";
    githubId = 508305;
    name = "Jaroslavas Pocepko";
  };
  vonfry = {
    email = "nixos@vonfry.name";
    github = "Vonfry";
    githubId = 3413119;
    name = "Vonfry";
  };
  vq = {
    email = "vq@erq.se";
    name = "Daniel Nilsson";
  };
  vrinek = {
    email = "vrinek@hey.com";
    github = "vrinek";
    name = "Kostas Karachalios";
    githubId = 81346;
  };
  vrthra = {
    email = "rahul@gopinath.org";
    github = "vrthra";
    githubId = 70410;
    name = "Rahul Gopinath";
  };
  vskilet = {
    email = "victor@sene.ovh";
    github = "vskilet";
    githubId = 7677567;
    name = "Victor SENE";
  };
  vtuan10 = {
    email = "mail@tuan-vo.de";
    github = "vtuan10";
    githubId = 16415673;
    name = "Van Tuan Vo";
  };
  vyorkin = {
    email = "vasiliy.yorkin@gmail.com";
    github = "vyorkin";
    githubId = 988849;
    name = "Vasiliy Yorkin";
  };
  vyp = {
    email = "elisp.vim@gmail.com";
    github = "vyp";
    githubId = 3889405;
    name = "vyp";
  };
  wackbyte = {
    name = "wackbyte";
    email = "wackbyte@pm.me";
    github = "wackbyte";
    githubId = 29505620;
    keys = [{
      longkeyid = "rsa4096/0x937F2AE5CCEFBF59";
      fingerprint = "E595 7FE4 FEF6 714B 1AD3  1483 937F 2AE5 CCEF BF59";
    }];
  };
  wakira = {
    name = "Sheng Wang";
    email = "sheng@a64.work";
    github = "wakira";
    githubId = 2338339;
    keys = [{
      longkeyid = "rsa4096/0x8C9B0A8FC0C0D862";
      fingerprint = "47F7 009E 3AE3 1DA7 988E  12E1 8C9B 0A8F C0C0 D862";
    }];
  };
  wamserma = {
    name = "Markus S. Wamser";
    email = "github-dev@mail2013.wamser.eu";
    github = "wamserma";
    githubId = 60148;
  };
  waynr = {
    name = "Wayne Warren";
    email = "wayne.warren.s@gmail.com";
    github = "waynr";
    githubId = 1441126;
  };
  wchresta = {
    email = "wchresta.nix@chrummibei.ch";
    github = "wchresta";
    githubId = 34962284;
    name = "wchresta";
  };
  wedens = {
    email = "kirill.wedens@gmail.com";
    name = "wedens";
  };
  wegank = {
    name = "Weijia Wang";
    email = "contact@weijia.wang";
    github = "wegank";
    githubId = 9713184;
  };
  weihua = {
    email = "luwh364@gmail.com";
    github = "weihua-lu";
    githubId = 9002575;
    name = "Weihua Lu";
  };
  welteki = {
    email = "welteki@pm.me";
    github = "welteki";
    githubId = 16267532;
    name = "Han Verstraete";
    keys = [{
      longkeyid = "rsa4096/0x11F7BAEA856743FF";
      fingerprint = "2145 955E 3F5E 0C95 3458  41B5 11F7 BAEA 8567 43FF";
    }];
  };
  wentasah = {
    name = "Michal Sojka";
    email = "wsh@2x.cz";
    github = "wentasah";
    githubId = 140542;
  };
  wheelsandmetal = {
    email = "jakob@schmutz.co.uk";
    github = "wheelsandmetal";
    githubId = 13031455;
    name = "Jakob Schmutz";
  };
  WhittlesJr = {
    email = "alex.joseph.whitt@gmail.com";
    github = "WhittlesJr";
    githubId = 19174984;
    name = "Alex Whitt";
  };
  whonore = {
    email = "wolfhonore@gmail.com";
    github = "whonore";
    githubId = 7121530;
    name = "Wolf Honoré";
  };
  wildsebastian = {
    name = "Sebastian Wild";
    email = "sebastian@wild-siena.com";
    github = "wildsebastian";
    githubId = 1215623;
    keys = [{
      longkeyid = "rsa4096/0x366A2940479A06FC";
      fingerprint = "DA03 D6C6 3F58 E796 AD26  E99B 366A 2940 479A 06FC";
    }];
  };
  willibutz = {
    email = "willibutz@posteo.de";
    github = "willibutz";
    githubId = 20464732;
    name = "Willi Butz";
  };
  willtim = {
    email = "tim.williams.public@gmail.com";
    name = "Tim Philip Williams";
  };
  willcohen = {
    email = "willcohen@users.noreply.github.com";
    github = "willcohen";
    githubId = 5185341;
    name = "Will Cohen";
  };
  winden = {
    email = "windenntw@gmail.com";
    name = "Antonio Vargas Gonzalez";
  };
  winpat = {
    email = "patrickwinter@posteo.ch";
    github = "winpat";
    githubId = 6016963;
    name = "Patrick Winter";
  };
  winter = {
    email = "nixos@winter.cafe";
    github = "winterqt";
    githubId = 78392041;
    name = "Winter";
  };
  wintrmvte = {
    name = "Jakub Lutczyn";
    email = "kubalutczyn@gmail.com";
    github = "wintrmvte";
    githubId = 41823252;
  };
  wirew0rm = {
    email = "alex@wirew0rm.de";
    github = "wirew0rm";
    githubId = 1202371;
    name = "Alexander Krimm";
  };
  wishfort36 = {
    email = "42300264+wishfort36@users.noreply.github.com";
    github = "wishfort36";
    githubId = 42300264;
    name = "wishfort36";
  };
  wizeman = {
    email = "rcorreia@wizy.org";
    github = "wizeman";
    githubId = 168610;
    name = "Ricardo M. Correia";
  };
  wjlroe = {
    email = "willroe@gmail.com";
    github = "wjlroe";
    githubId = 43315;
    name = "William Roe";
  };
  wldhx = {
    email = "wldhx+nixpkgs@wldhx.me";
    github = "wldhx";
    githubId = 15619766;
    name = "wldhx";
  };
  wmertens = {
    email = "Wout.Mertens@gmail.com";
    github = "wmertens";
    githubId = 54934;
    name = "Wout Mertens";
  };
  wnklmnn = {
    email = "pascal@wnklmnn.de";
    github = "wnklmnn";
    githubId = 9423014;
    name = "Pascal Winkelmann";
  };
  woffs = {
    email = "github@woffs.de";
    github = "woffs";
    githubId = 895853;
    name = "Frank Doepper";
  };
  wohanley = {
    email = "me@wohanley.com";
    github = "wohanley";
    githubId = 1322287;
    name = "William O'Hanley";
  };
  woky = {
    email = "pampu.andrei@pm.me";
    github = "andreisergiu98";
    githubId = 11740700;
    name = "Andrei Pampu";
  };
  wolfangaukang = {
    email = "liquid.query960@4wrd.cc";
    github = "wolfangaukang";
    githubId = 8378365;
    name = "P. R. d. O.";
  };
  womfoo = {
    email = "kranium@gikos.net";
    github = "womfoo";
    githubId = 1595132;
    name = "Kranium Gikos Mendoza";
  };
  worldofpeace = {
    email = "worldofpeace@protonmail.ch";
    github = "worldofpeace";
    githubId = 28888242;
    name = "WORLDofPEACE";
  };
  wr0belj = {
    name = "Jakub Wróbel";
    email = "wrobel.jakub@protonmail.com";
    github = "wr0belj";
    githubId = 40501814;
  };
  wscott = {
    email = "wsc9tt@gmail.com";
    github = "wscott";
    githubId = 31487;
    name = "Wayne Scott";
  };
  wucke13 = {
    email = "info@wucke13.de";
    github = "wucke13";
    githubId = 20400405;
    name = "Wucke";
  };
  wykurz = {
    email = "wykurz@gmail.com";
    github = "wykurz";
    githubId = 483465;
    name = "Mateusz Wykurz";
  };
  wulfsta = {
    email = "wulfstawulfsta@gmail.com";
    github = "Wulfsta";
    githubId = 13378502;
    name = "Wulfsta";
  };
  wunderbrick = {
    name = "Andrew Phipps";
    email = "lambdafuzz@tutanota.com";
    github = "wunderbrick";
    githubId = 52174714;
  };
  wyvie = {
    email = "elijahrum@gmail.com";
    github = "wyvie";
    githubId = 3992240;
    name = "Elijah Rum";
  };
  x3ro = {
    name = "^x3ro";
    email = "nix@x3ro.dev";
    github = "x3rAx";
    githubId = 2268851;
  };
  xaverdh = {
    email = "hoe.dom@gmx.de";
    github = "xaverdh";
    githubId = 11050617;
    name = "Dominik Xaver Hörl";
  };
  xbreak = {
    email = "xbreak@alphaware.se";
    github = "xbreak";
    githubId = 13489144;
    name = "Calle Rosenquist";
  };
  xdhampus = {
    name = "Hampus";
    email = "16954508+xdHampus@users.noreply.github.com";
    github = "xdHampus";
    githubId = 16954508;
  };
  xe = {
    email = "me@christine.website";
    matrix = "@withoutwithin:matrix.org";
    github = "Xe";
    githubId = 529003;
    name = "Christine Dodrill";
  };
  xeji = {
    email = "xeji@cat3.de";
    github = "xeji";
    githubId = 36407913;
    name = "Uli Baum";
  };
  xfnw = {
    email = "xfnw+nixos@riseup.net";
    github = "xfnw";
    githubId = 66233223;
    name = "Owen";
  };
  xfix = {
    email = "konrad@borowski.pw";
    matrix = "@xfix:matrix.org";
    github = "xfix";
    githubId = 1297598;
    name = "Konrad Borowski";
  };
  xiorcale = {
    email = "quentin.vaucher@pm.me";
    github = "xiorcale";
    githubId = 17534323;
    name = "Quentin Vaucher";
  };
  xnaveira = {
    email = "xnaveira@gmail.com";
    github = "xnaveira";
    githubId = 2534411;
    name = "Xavier Naveira";
  };
  xnwdd = {
    email = "nwdd+nixos@no.team";
    github = "xnwdd";
    githubId = 3028542;
    name = "Guillermo NWDD";
  };
  xrelkd = {
    email = "46590321+xrelkd@users.noreply.github.com";
    github = "xrelkd";
    githubId = 46590321;
    name = "xrelkd";
  };
  xurei = {
    email = "olivier.bourdoux@gmail.com";
    github = "xurei";
    githubId = 621695;
    name = "Olivier Bourdoux";
  };
  xvapx = {
    email = "marti.serra.coscollano@gmail.com";
    github = "xvapx";
    githubId = 11824817;
    name = "Marti Serra";
  };
  xworld21 = {
    email = "1962985+xworld21@users.noreply.github.com";
    github = "xworld21";
    githubId = 1962985;
    name = "Vincenzo Mantova";
  };
  xzfc = {
    email = "xzfcpw@gmail.com";
    github = "xzfc";
    githubId = 5121426;
    name = "Albert Safin";
  };
  y0no = {
    email = "y0no@y0no.fr";
    github = "y0no";
    githubId = 2242427;
    name = "Yoann Ono";
  };
  yana = {
    email = "yana@riseup.net";
    github = "alpakido";
    githubId = 1643293;
    name = "Yana Timoshenko";
  };
  yarny = {
    email = "41838844+Yarny0@users.noreply.github.com";
    github = "Yarny0";
    githubId = 41838844;
    name = "Yarny";
  };
  yarr = {
    email = "savraz@gmail.com";
    github = "Eternity-Yarr";
    githubId = 3705333;
    name = "Dmitry V.";
  };
  yayayayaka = {
    email = "nixpkgs@uwu.is";
    matrix = "@lara:uwu.is";
    github = "yayayayaka";
    githubId = 73759599;
    name = "Lara A.";
  };
  yesbox = {
    email = "jesper.geertsen.jonsson@gmail.com";
    github = "yesbox";
    githubId = 4113027;
    name = "Jesper Geertsen Jonsson";
  };
  yinfeng = {
    email = "lin.yinfeng@outlook.com";
    github = "linyinfeng";
    githubId = 11229748;
    name = "Lin Yinfeng";
  };
  ylecornec = {
    email = "yves.stan.lecornec@tweag.io";
    github = "ylecornec";
    githubId = 5978566;
    name = "Yves-Stan Le Cornec";
  };
  ylwghst = {
    email = "ylwghst@onionmail.info";
    github = "ylwghst";
    githubId = 26011724;
    name = "Burim Augustin Berisa";
  };
  yl3dy = {
    email = "aleksandr.kiselyov@gmail.com";
    github = "yl3dy";
    githubId = 1311192;
    name = "Alexander Kiselyov";
  };
  yochai = {
    email = "yochai@titat.info";
    github = "yochai";
    githubId = 1322201;
    name = "Yochai";
  };
  yoctocell = {
    email = "public@yoctocell.xyz";
    github = "yoctocell";
    githubId = 40352765;
    name = "Yoctocell";
  };
  yorickvp = {
    email = "yorickvanpelt@gmail.com";
    matrix = "@yorickvp:matrix.org";
    github = "yorickvp";
    githubId = 647076;
    name = "Yorick van Pelt";
  };
  yrashk = {
    email = "yrashk@gmail.com";
    github = "yrashk";
    githubId = 452;
    name = "Yurii Rashkovskii";
  };
  yrd = {
    name = "Yannik Rödel";
    email = "nix@yannik.info";
    github = "yrd";
    githubId = 1820447;
  };
  ysndr = {
    email = "me@ysndr.de";
    github = "ysndr";
    githubId = 7040031;
    name = "Yannik Sander";
  };
  yuriaisaka = {
    email = "yuri.aisaka+nix@gmail.com";
    github = "yuriaisaka";
    githubId = 687198;
    name = "Yuri Aisaka";
  };
  yurrriq = {
    email = "eric@ericb.me";
    github = "yurrriq";
    githubId = 1866448;
    name = "Eric Bailey";
  };
  Yumasi = {
    email = "gpagnoux@gmail.com";
    github = "Yumasi";
    githubId = 24368641;
    name = "Guillaume Pagnoux";
    keys = [{
      longkeyid = "rsa4096/0xEC5065899AEAAF4C";
      fingerprint = "85F8 E850 F8F2 F823 F934  535B EC50 6589 9AEA AF4C";
    }];
  };
  yuka = {
    email = "yuka@yuka.dev";
    matrix = "@yuka:yuka.dev";
    github = "yu-re-ka";
    githubId = 86169957;
    name = "Yureka";
  };
  yusdacra = {
    email = "y.bera003.06@protonmail.com";
    matrix = "@yusdacra:nixos.dev";
    github = "yusdacra";
    githubId = 19897088;
    name = "Yusuf Bera Ertan";
    keys = [{
      longkeyid = "rsa2048/0x61807181F60EFCB2";
      fingerprint = "9270 66BD 8125 A45B 4AC4 0326 6180 7181 F60E FCB2";
    }];
  };
  yuu = {
    email = "yuuyin@protonmail.com";
    github = "yuuyins";
    githubId = 86538850;
    name = "Yuu Yin";
    keys = [{
      longkeyid = "rsa4096/0x416F303B43C20AC3";
      fingerprint = "9F19 3AE8 AA25 647F FC31  46B5 416F 303B 43C2 0AC3";
    }];
  };
  yvesf = {
    email = "yvesf+nix@xapek.org";
    github = "yvesf";
    githubId = 179548;
    name = "Yves Fischer";
  };
  yvt = {
    email = "i@yvt.jp";
    github = "yvt";
    githubId = 5253988;
    name = "yvt";
  };
  maggesi = {
    email = "marco.maggesi@gmail.com";
    github = "maggesi";
    githubId = 1809783;
    name = "Marco Maggesi";
  };
  zachcoyle = {
    email = "zach.coyle@gmail.com";
    github = "zachcoyle";
    githubId = 908716;
    name = "Zach Coyle";
  };
  zagy = {
    email = "cz@flyingcircus.io";
    github = "zagy";
    githubId = 568532;
    name = "Christian Zagrodnick";
  };
  zakame = {
    email = "zakame@zakame.net";
    github = "zakame";
    githubId = 110625;
    name = "Zak B. Elep";
  };
  zalakain = {
    email = "ping@umazalakain.info";
    github = "umazalakain";
    githubId = 1319905;
    name = "Uma Zalakain";
  };
  zaninime = {
    email = "francesco@zanini.me";
    github = "zaninime";
    githubId = 450885;
    name = "Francesco Zanini";
  };
  zarelit = {
    email = "david@zarel.net";
    github = "zarelit";
    githubId = 3449926;
    name = "David Costa";
  };
  zauberpony = {
    email = "elmar@athmer.org";
    github = "zauberpony";
    githubId = 250877;
    name = "Elmar Athmer";
  };
  zakkor = {
    email = "edward.dalbon@gmail.com";
    github = "zakkor";
    githubId = 6191421;
    name = "Edward d'Albon";
  };
  zef = {
    email = "zef@zef.me";
    name = "Zef Hemel";
  };
  zeratax = {
    email = "mail@zera.tax";
    github = "ZerataX";
    githubId = 5024958;
    name = "Jona Abdinghoff";
    keys = [{
      longkeyid = "rsa4096/0x8333735E784DF9D4";
      fingerprint = "44F7 B797 9D3A 27B1 89E0  841E 8333 735E 784D F9D4";
    }];
  };
  zfnmxt = {
    name = "zfnmxt";
    email = "zfnmxt@zfnmxt.com";
    github = "zfnmxt";
    githubId = 37446532;
  };
  zgrannan = {
    email = "zgrannan@gmail.com";
    github = "zgrannan";
    githubId = 1141948;
    name = "Zack Grannan";
  };
  zhaofengli = {
    email = "hello@zhaofeng.li";
    matrix = "@zhaofeng:zhaofeng.li";
    github = "zhaofengli";
    githubId = 2189609;
    name = "Zhaofeng Li";
  };
  zimbatm = {
    email = "zimbatm@zimbatm.com";
    github = "zimbatm";
    githubId = 3248;
    name = "zimbatm";
  };
  Zimmi48 = {
    email = "theo.zimmermann@univ-paris-diderot.fr";
    github = "Zimmi48";
    githubId = 1108325;
    name = "Théo Zimmermann";
  };
  zohl = {
    email = "zohl@fmap.me";
    github = "zohl";
    githubId = 6067895;
    name = "Al Zohali";
  };
  zookatron = {
    email = "tim@zookatron.com";
    github = "zookatron";
    githubId = 1772064;
    name = "Tim Zook";
  };
  zopieux = {
    email = "zopieux@gmail.com";
    github = "zopieux";
    githubId = 81353;
    name = "Alexandre Macabies";
  };
  zowoq = {
    email = "59103226+zowoq@users.noreply.github.com";
    github = "zowoq";
    githubId = 59103226;
    name = "zowoq";
  };
  zraexy = {
    email = "zraexy@gmail.com";
    github = "zraexy";
    githubId = 8100652;
    name = "David Mell";
  };
  ztzg = {
    email = "dd@crosstwine.com";
    github = "ztzg";
    githubId = 393108;
    name = "Damien Diederen";
  };
  zx2c4 = {
    email = "Jason@zx2c4.com";
    github = "zx2c4";
    githubId = 10643;
    name = "Jason A. Donenfeld";
  };
  zyansheep = {
    email = "zyansheep@protonmail.com";
    github = "zyansheep";
    githubId = 20029431;
    name = "Zyansheep";
  };
  zzamboni = {
    email = "diego@zzamboni.org";
    github = "zzamboni";
    githubId = 32876;
    name = "Diego Zamboni";
  };
  turbomack = {
    email = "marek.faj@gmail.com";
    github = "turboMaCk";
    githubId = 2130305;
    name = "Marek Fajkus";
  };
  melling = {
    email = "mattmelling@fastmail.com";
    github = "mattmelling";
    githubId = 1215331;
    name = "Matt Melling";
  };
  wd15 = {
    email = "daniel.wheeler2@gmail.com";
    github = "wd15";
    githubId = 1986844;
    name = "Daniel Wheeler";
  };
  misuzu = {
    email = "bakalolka@gmail.com";
    github = "misuzu";
    githubId = 248143;
    name = "misuzu";
  };
  zokrezyl = {
    email = "zokrezyl@gmail.com";
    github = "zokrezyl";
    githubId = 51886259;
    name = "Zokre Zyl";
  };
  rakesh4g = {
    email = "rakeshgupta4u@gmail.com";
    github = "rakesh4g";
    githubId = 50867187;
    name = "Rakesh Gupta";
  };
  mlatus = {
    email = "wqseleven@gmail.com";
    github = "Ninlives";
    githubId = 17873203;
    name = "mlatus";
  };
  waiting-for-dev = {
    email = "marc@lamarciana.com";
    github = "waiting-for-dev";
    githubId = 52650;
    name = "Marc Busqué";
  };
  snglth = {
    email = "illia@ishestakov.com";
    github = "snglth";
    githubId = 8686360;
    name = "Illia Shestakov";
  };
  masaeedu = {
    email = "masaeedu@gmail.com";
    github = "masaeedu";
    githubId = 3674056;
    name = "Asad Saeeduddin";
  };
  matthewcroughan = {
    email = "matt@croughan.sh";
    github = "matthewcroughan";
    githubId = 26458780;
    name = "Matthew Croughan";
  };
  ngerstle = {
    name = "Nicholas Gerstle";
    email = "ngerstle@gmail.com";
    github = "ngerstle";
    githubId = 1023752;
  };
  shardy = {
    email = "shardul@baral.ca";
    github = "shardulbee";
    githubId = 16765155;
    name = "Shardul Baral";
  };
  xavierzwirtz = {
    email = "me@xavierzwirtz.com";
    github = "xavierzwirtz";
    githubId = 474343;
    name = "Xavier Zwirtz";
  };
  ymarkus = {
    name = "Yannick Markus";
    email = "nixpkgs@ymarkus.dev";
    github = "ymarkus";
    githubId = 62380378;
  };
  ymatsiuk = {
    name = "Yurii Matsiuk";
    email = "ymatsiuk@users.noreply.github.com";
    github = "ymatsiuk";
    githubId = 24990891;
    keys = [{
      longkeyid = "rsa4096/0x61302290298601AA";
      fingerprint = "7BB8 84B5 74DA FDB1 E194  ED21 6130 2290 2986 01AA";
    }];
  };
  ymeister = {
    name = "Yuri Meister";
    email = "47071325+ymeister@users.noreply.github.com";
    github = "ymeister";
    githubId = 47071325;
  };
  cpcloud = {
    name = "Phillip Cloud";
    email = "417981+cpcloud@users.noreply.github.com";
    github = "cpcloud";
    githubId = 417981;
  };
  davegallant = {
    name = "Dave Gallant";
    email = "davegallant@gmail.com";
    github = "davegallant";
    githubId = 4519234;
  };
  saulecabrera = {
    name = "Saúl Cabrera";
    email = "saulecabrera@gmail.com";
    github = "saulecabrera";
    githubId = 1423601;
  };
  tfmoraes = {
    name = "Thiago Franco de Moraes";
    email = "351108+tfmoraes@users.noreply.github.com";
    github = "tfmoraes";
    githubId = 351108;
  };
  deifactor = {
    name = "Ash Zahlen";
    email = "ext0l@riseup.net";
    github = "deifactor";
    githubId = 30192992;
  };
  fzakaria = {
    name = "Farid Zakaria";
    email = "farid.m.zakaria@gmail.com";
    matrix = "@fzakaria:matrix.org";
    github = "fzakaria";
    githubId = 605070;
  };
  nagisa = {
    name = "Simonas Kazlauskas";
    email = "nixpkgs@kazlauskas.me";
    github = "nagisa";
    githubId = 679122;
  };
  yshym = {
    name = "Yevhen Shymotiuk";
    email = "yshym@pm.me";
    github = "yshym";
    githubId = 44244245;
  };
  hmenke = {
    name = "Henri Menke";
    email = "henri@henrimenke.de";
    matrix = "@hmenke:matrix.org";
    github = "hmenke";
    githubId = 1903556;
    keys = [{
      longkeyid = "rsa4096/0xD65C9AFB4C224DA3";
      fingerprint = "F1C5 760E 45B9 9A44 72E9  6BFB D65C 9AFB 4C22 4DA3";
    }];
  };
  berbiche = {
    name = "Nicolas Berbiche";
    email = "nicolas@normie.dev";
    github = "berbiche";
    githubId = 20448408;
    keys = [{
      longkeyid = "rsa4096/0xB461292445C6E696";
      fingerprint = "D446 E58D 87A0 31C7 EC15  88D7 B461 2924 45C6 E696";
    }];
  };
  wenngle = {
    name = "Zeke Stephens";
    email = "zekestephens@gmail.com";
    github = "wenngle";
    githubId = 63376671;
  };
  yanganto = {
    name = "Antonio Yang";
    email = "yanganto@gmail.com";
    github = "yanganto";
    githubId = 10803111;
  };
  starcraft66 = {
    name = "Tristan Gosselin-Hane";
    email = "starcraft66@gmail.com";
    github = "starcraft66";
    githubId = 1858154;
    keys = [{
      longkeyid = "rsa4096/0x9D98CDACFF04FD78";
      fingerprint = "8597 4506 EC69 5392 0443  0805 9D98 CDAC FF04 FD78";
    }];
  };
  hloeffler = {
    name = "Hauke Löffler";
    email = "nix@hauke-loeffler.de";
    github = "hloeffler";
    githubId = 6627191;
  };
  wilsonehusin = {
    name = "Wilson E. Husin";
    email = "wilsonehusin@gmail.com";
    github = "wilsonehusin";
    githubId = 14004487;
  };
  bb2020 = {
    email = "bb2020@users.noreply.github.com";
    github = "bb2020";
    githubId = 19290397;
    name = "Tunc Uzlu";
  };
  pulsation = {
    name = "Philippe Sam-Long";
    email = "1838397+pulsation@users.noreply.github.com";
    github = "pulsation";
    githubId = 1838397;
  };
  princemachiavelli = {
    name = "Josh Hoffer";
    email = "jhoffer@sansorgan.es";
    matrix = "@princemachiavelli:matrix.org";
    github = "princemachiavelli";
    githubId = 2730968;
    keys = [{
      longkeyid = "ed25519/0x83124F97A318EA18";
      fingerprint = "DD54 130B ABEC B65C 1F6B  2A38 8312 4F97 A318 EA18";
    }];
  };
  ydlr = {
    name = "ydlr";
    email = "ydlr@ydlr.io";
    github = "ydlr";
    githubId = 58453832;
    keys = [{
      longkeyid = "rsa4096/0x43AB44130A29AD9D";
      fingerprint = "FD0A C425 9EF5 4084 F99F 9B47 2ACC 9749 7C68 FAD4";
    }];
  };
  zane = {
    name = "Zane van Iperen";
    email = "zane@zanevaniperen.com";
    github = "vs49688";
    githubId = 4423262;
    keys = [{
      longkeyid = "rsa4096/0x68616B2D8AC4DCC5";
      fingerprint = "61AE D40F 368B 6F26 9DAE  3892 6861 6B2D 8AC4 DCC5";
    }];
  };
  zbioe = {
    name = "Iury Fukuda";
    email = "zbioe@protonmail.com";
    github = "zbioe";
    githubId = 7332055;
  };
  zenithal = {
    name = "zenithal";
    email = "i@zenithal.me";
    github = "ZenithalHourlyRate";
    githubId = 19512674;
    keys = [{
      longkeyid = "rsa4096/0x87E17EEF9B18B6C9";
      fingerprint = "1127 F188 280A E312 3619  3329 87E1 7EEF 9B18 B6C9";
    }];
  };
  zeri = {
    name = "zeri";
    email = "68825133+zeri42@users.noreply.github.com";
    matrix = "@zeri:matrix.org";
    github = "zeri42";
    githubId = 68825133;
  };
  zoedsoupe = {
    github = "zoedsoupe";
    githubId = 44469426;
    name = "Zoey de Souza Pessanha";
    email = "zoey.spessanha@outlook.com";
    keys = [{
      longkeyid = "rsa4096/0x1E1E889CDBD6A315";
      fingerprint = "EAA1 51DB 472B 0122 109A  CB17 1E1E 889C DBD6 A315";
    }];
  };
  zombiezen = {
    name = "Ross Light";
    email = "ross@zombiezen.com";
    github = "zombiezen";
    githubId = 181535;
  };
  zseri = {
    name = "zseri";
    email = "zseri.devel@ytrizja.de";
    github = "zseri";
    githubId = 1618343;
    keys = [{
      longkeyid = "rsa4096/0x229E63AE5644A96D";
      fingerprint = "7AFB C595 0D3A 77BD B00F  947B 229E 63AE 5644 A96D";
    }];
  };
  zupo = {
    name = "Nejc Zupan";
    email = "nejczupan+nix@gmail.com";
    github = "zupo";
    githubId = 311580;
  };
  sei40kr = {
    name = "Seong Yong-ju";
    email = "sei40kr@gmail.com";
    github = "sei40kr";
    githubId = 11665236;
  };
  vdot0x23 = {
    name = "Victor Büttner";
    email = "nix.victor@0x23.dk";
    github = "vdot0x23";
    githubId = 40716069;
  };
  jpagex = {
    name = "Jérémy Pagé";
    email = "contact@jeremypage.me";
    github = "jpagex";
    githubId = 635768;
  };
  portothree = {
    name = "Gustavo Porto";
    email = "gustavoporto@ya.ru";
    github = "portothree";
    githubId = 3718120;
  };
  pwoelfel = {
    name = "Philipp Woelfel";
    email = "philipp.woelfel@gmail.com";
    github = "PhilippWoelfel";
    githubId = 19400064;
  };
  qbit = {
    name = "Aaron Bieber";
    email = "aaron@bolddaemon.com";
    github = "qbit";
    githubId = 68368;
    matrix = "@qbit:tapenet.org";
    keys = [{
      longkeyid = "rsa4096/0x1F81112D62A9ADCE";
      fingerprint = "3586 3350 BFEA C101 DB1A 4AF0 1F81 112D 62A9 ADCE";
    }];
  };
  ameer = {
    name = "Ameer Taweel";
    email = "ameertaweel2002@gmail.com";
    github = "AmeerTaweel";
    githubId = 20538273;
  };
  nigelgbanks = {
    name = "Nigel Banks";
    email = "nigel.g.banks@gmail.com";
    github = "nigelgbanks";
    githubId = 487373;
  };
}
