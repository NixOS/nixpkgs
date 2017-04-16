#! /usr/bin/perl -w
######################################################################################################################
#
# Linux Installations Script
#
# $Id: install-linux.pl 132269 2012-11-26 13:13:10Z dfrohn $
#
######################################################################################################################

use strict;
use File::Path;
use File::Basename;
use File::Copy;
use Getopt::Long;

######################################################################################################################
# Einige Konfigurationskonstanten
######################################################################################################################
my $FILE_EULA = 'EULA.txt';
my $DOWNLOAD_SERVER = "http://dls.photoprintit.com";
my $KEYACCID = '16523';
my $CLIENTID = '18';
my $HPS_VER = '6.0.3';
my $VENDOR_NAME = 'CEWE';
my $APPLICATION_NAME = 'Mein CEWE FOTOBUCH';
my $INSTALL_DIR_DEFAULT = 'Mein CEWE FOTOBUCH';
my $HAS_PHOTOFUN = 'false';
my $HAS_CANVAS = 'false';
my $HAS_POSTER = 'false';
my $HAS_PREMIUMFOTO = 'false';
my $HAS_BUDGETFOTO = 'false';
my $HAS_CALENDARS = 'false';
my $HAS_FOTOBOOKS = 'false';
my $HAS_THEME_DESIGN = 'true';
my $HAS_THEME_DMBABY = 'false';
my $HAS_THEME_ALB = 'true';
my $PROGRAM_NAME_FOTOSHOW = 'CEWE FOTOSCHAU';


######################################################################################################################
# Einige Konstanten
######################################################################################################################
my $MIME_TYPE = 'application/x-hps-mcf';
my $APP_ICON_FILE_NAME = 'cewe-hps-500';
my $DESKTOP_ICON_PATH = '/Resources/keyaccount/32.ico';
my $SERVICES_XML_PATH = '/Resources/services.xml';
my $AFFILIATE_ID = 'om_coop_website_1431875510_cwfbde_17050311                      ';


######################################################################################################################
# Texte
######################################################################################################################
my @TRANSLATABLE;
my @TRANSLATABLE_ERRORS;

$TRANSLATABLE[0]  = "ja";
$TRANSLATABLE[1]  = "j";
$TRANSLATABLE[2]  = "nein";
$TRANSLATABLE[3]  = "n";
$TRANSLATABLE[4]  = "Dieses Script ist Ihnen bei der Installation von '\033[1m%1\$s\033[0m' auf Ihrem Rechner behilflich und leitet Sie Schritt für Schritt durch den Installationsprozess.\n\n\n";
$TRANSLATABLE[5]  = "Bitte lesen Sie die EULA (End User License Agreement) sorgfältig durch. Im Anschluss daran müssen Sie die EULA akzeptieren.\n\tInnerhalb der EULA können Sie mit den Pfeiltasten navigieren. Durch drücken der Taste '\033[1mq\033[0m' verlassen Sie die EULA.\n\tWeiter mit <CR>.";
$TRANSLATABLE[6]  = "\tAkzeptieren Sie die EULA? [%1\$s/\033[1m%2\$s\033[0m] ";
$TRANSLATABLE[7]  = "\033[0m\033[1m'%1\$s'\033[0m kann leider nicht auf Ihrem Rechner installiert werden.\n\n\n";
$TRANSLATABLE[8]  = "Wo soll '\033[1m%1\$s\033[0m' installiert werden? [\033[1m%2\$s\033[0m] ";
$TRANSLATABLE[9]  = "\tWollen Sie die Installation fortsetzen und die benötigten Daten aus dem Internet herunter laden? [\033[1m%1\$s\033[0m/%2\$s] ";
$TRANSLATABLE[10] = "\tDownloading: '%1\$s'\n";
$TRANSLATABLE[11] = "Die benötigten Dateien werden nun in das Installationsverzeichnis entpackt.\n";
$TRANSLATABLE[12] = "\nHerzlichen Glückwunsch!\nSie haben erfolgreich \033[1m'%1\$s'\033[0m auf Ihrem Rechner installiert.\nZum Starten führen Sie bitte die Datei '%2\$s' aus.\n\nViel Spaß!\n";
$TRANSLATABLE[13] = "Soll erneut versucht werden die Datei herunter zu laden? [%1\$s/\033[1m%2\$s\033[0m] ";
$TRANSLATABLE[14] = "\t    %1\$-18s %2\$20s %3\$9s (%4\$5s)\n";
$TRANSLATABLE[15] = "\tEs müssen noch insgesamt %1\$.2fMB Daten aus dem Internet heruntergeladen werden.\n";
$TRANSLATABLE[16] = "Für eine erfolgreiche Installation müssen noch die folgenden Pakete aus dem Internet herunter geladen werden.\n";
$TRANSLATABLE[17] = "Die herunter geladenen Installationspakete wurden nach der Installation nicht gelöscht und befinden sich im aktuellen Verzeichnis.";
$TRANSLATABLE[18] = "Die herunter geladenen Installationspakete wurden nach der Installation nicht gelöscht und wurden zusammen mit diesem Installationsscript nach %1\$s kopiert.";
$TRANSLATABLE[19] = "Das angegebene Verzeichnis existiert nicht. Soll es angelegt werden? [\033[1m%1\$s\033[0m/%2\$s] ";
$TRANSLATABLE[20] = "Kommandozeilenoptionen:\n   -h; --help\n   -i; --installDir=<DIR>\tDas Verzeichnis in das '%1\$s' installiert werden soll.\n   -k; --keepPackages\t\tDie heruntergeladenen Pakete werden nicht gelöscht und können für eine weitere Installation benutzt werden.\n   -w; --workingDir=<DIR>\tDas Verzeichnis in dem temporäre Dateien abgelegt werden können.\n   -v; --verbose\t\tGibt Informationen beim Download aus.\n\nDas Script sucht im aktuellen Verzeichnis nach den Installationspaketen. Werden die Pakete dort nicht gefunden\nso werden sie aus dem Internet heruntergeladen\nTemporäre Dateien werden in das aktuelle oder das mit --workingDir angegebene Verzeichnis gespeichert. Ist das, wegen fehlender Berechtigungen, nicht möglich werden die temporären Dateien nach /tmp gespeichert.\n";

$TRANSLATABLE_ERRORS[0]  = "Für die Kommandozeilenoptionen '--installDir' und '--workingDir' ist die Angabe eines Verzeichnisses zwingend erforderlich!\n";
$TRANSLATABLE_ERRORS[1]  = "Bei einem Update ist die Angabe des Installationsverzeichnisses mit '--installDir' zwingend erforderlich!\n";
$TRANSLATABLE_ERRORS[2]  = "Das angegebene Arbeitsverzeichnis '%1\$s' existiert nicht!\n";
$TRANSLATABLE_ERRORS[3]  = "Das Arbeitsverzeichnis konnte nicht ermittelt werden!\n";
$TRANSLATABLE_ERRORS[4]  = "Für die korrekte Ausführung des Scriptes wird das Programm '%1\$s' benötigt!\n";
$TRANSLATABLE_ERRORS[5]  = "Die Datei '%1\$s' kann nicht gefunden werden!\n";
$TRANSLATABLE_ERRORS[6]  = "\tSie haben die EULA nicht akzeptiert!\n\t%1\$s";
$TRANSLATABLE_ERRORS[7]  = "Im angegebenen Verzeichnis können keine symbolischen Links angelegt werden. Dies ist aber für die Installation von '%1\$s' zwingend erforderlich!\n";
$TRANSLATABLE_ERRORS[8]  = "Das Herunterladen der Datei '%1\$s' ist fehlgeschlagen!\n";
$TRANSLATABLE_ERRORS[9]  = "Die Datei '%1\$s' kann nicht geöffnet werden!\n";
$TRANSLATABLE_ERRORS[10] = "Die Plattform konnte nicht ermittelt werden! 'uname -m' liefert weder 'i686' noch 'x86_64' sondern '%1\$s'.\n";
$TRANSLATABLE_ERRORS[11] = "Die Datei '%1\$s' konnte nicht heruntergeladen werden!\n";
$TRANSLATABLE_ERRORS[12] = "Das Verzeichnis '%1\$s' konnte nicht angelegt werden.\n";
$TRANSLATABLE_ERRORS[13] = "Die Datei '%1\$s' kann nicht entpackt werden!\n";
$TRANSLATABLE_ERRORS[14] = "Die Datei '%1\$s' konnte nicht nach '%2\$s' kopiert werden!\n";
$TRANSLATABLE_ERRORS[15] = "Die Prüfsumme der heruntergeladenen Datei '%1\$s' stimmt nicht!\n";
$TRANSLATABLE_ERRORS[16] = "Die Datei '%1\$s' konnte nicht nach '%2\$s' herunter geladen werden!\n";
$TRANSLATABLE_ERRORS[17] = "Die benötigten Pakete konnten nicht ermittelt werden!\n";

my @ANSWER_YES_LIST = ($TRANSLATABLE[0], $TRANSLATABLE[1]);
my @ANSWER_NO_LIST  = ($TRANSLATABLE[2], $TRANSLATABLE[3]);


######################################################################################################################
# AB HIER SOLLTE NICHTS MEHR GEAENDERT WERDEN
######################################################################################################################
my $INSTALL_DIR_DEF = "$VENDOR_NAME/$INSTALL_DIR_DEFAULT";
my $INDEX_FILE_PATH_ON_SERVER = "/download/Data/$KEYACCID/hps/$CLIENTID-index-$HPS_VER.txt";
my $LOG_FILE_DIR = '.log';
my @REQUIRED_PROGRAMMS = ("unzip", "md5sum", "less", "wget", "uname");
my $DESKTOP_FILE_FORMAT = "[Desktop Entry]\n".
						"Version=1.0\n".
						"Encoding=UTF-8\n".
						"Name=$APPLICATION_NAME\n".
						"Name[de]=$APPLICATION_NAME\n".
						"Exec=\"%s/$APPLICATION_NAME\"\n".
						"Path=%s\n".
						"StartupNotify=true\n".
						"Terminal=false\n".
						"Type=Application\n".
						"Icon=$APP_ICON_FILE_NAME\n".
						"Categories=Graphics;\n".
						"MimeType=$MIME_TYPE\n";
my $MIME_TYPE_FILE_FORMAT = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".
						"<mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>\n".
						"<mime-type type=\"%s\">\n".
						"<comment>%s</comment>\n".
						"<glob pattern=\"*.mcf\"/>\n".
						"</mime-type>\n".
						"</mime-info>";
my $SERVICES_XML_FORMAT = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>".
						"<services>".
						"<service name=\"a\">t856EvnDTL56xD5fHQnWrzqVk6Xj3we4xGYHfShPmkqXtCzbI21eqJ57eIHVViAg</service>".
						"<service name=\"b\">SNCxjcl5y86nasXrdmtwTWWbBmFs3j21rZOVvoZT9HleOfGJR7FGgZiXsS623ctV</service>".
						"<service name=\"c\">7iIwPfB9c6TIRuf9SPd7I1j25Pex9atTL9TDepMD6nkAyDliZhvIlJOC2tm9pcyQ</service>".
						"<service name=\"d\">%s</service>".
						"<service name=\"e\">EQBuKJf7pzVIbNXzz19PlwkVpERC5KfsWJbG4cazpn3PFC5Rtz4O3V87KcWfMgxK</service>".
						"<service name=\"f\">8ksOkroMJFn1Es3zVJyzxJggNaXiMuLKBfPLBtCyek1bZBcTy29gaU7nm75ZYIxz</service>".
						"<service name=\"g\">xHuXMWCLmtrwNIBvqVB9BAyPjNpEa9gNuybXU51bKsryDqc2UJxSQXM8yIhbIarq</service>".
						"<service name=\"h\">sKTtqevc5EdBSwi3bZkngwl4NSolB8vFc7kPWeAEB4Y1ySgUIgcjJGxKlOll8c8e</service>".
						"</services>\n";

my $DOWNLOAD_START_URL="http://dls.photoprintit.com/api/feedback/$KEYACCID/hps/<update>downloadstart.$AFFILIATE_ID/linux";
my $DOWNLOAD_COMPLETE_URL="http://dls.photoprintit.com/api/feedback/$KEYACCID/hps/<update>downloadcomplete.$AFFILIATE_ID/linux";
my $INSTALLATION_COMPLETE_URL="http://dls.photoprintit.com/api/feedback/$KEYACCID/hps/<update>installationcomplete.$AFFILIATE_ID/linux";



######################################################################################################################
# Variablen
######################################################################################################################
my $indexContent;			# Enthält den Inhalt der Index-Datei
my @filesToDownload;		# Enthält die Dateinamen die heruntergeladen werden müssen
my @downloadedFiles;		# Enthält die Dateinamen der heruntergeladenen Dateien
my @filesToRemove;			# Enthält die Dateinamen der Dateien die am Ende des Scriptes gelöscht werden müssen.
my $fileName;				# Enthält den Namen der aktuell zu bearbeitenden Datei
my $update;
my $upgrade;
my $installDir = "";
my $sourceDir = "";
my $changeInstallDir = 1;
my $verbose;
my $keepPackages = 0;
my $workingDir = "";



######################################################################################################################
# Zeige einen kleinen Hilfetext an
######################################################################################################################
sub showHelp {
	printf ($TRANSLATABLE[4], $APPLICATION_NAME);
	printf ($TRANSLATABLE[20], $APPLICATION_NAME);

	exit(0);
}



######################################################################################################################
# Parse Kommandozeilen Parameter
######################################################################################################################
sub getOptions {
	$update = 0;
	$upgrade = 0;
	$verbose = 0;
	$installDir = "";
	$workingDir = "";
	my $showHelp = 0;

	GetOptions("installdir=s" => \$installDir,
			"update" => \$update,
			"upgrade" => \$upgrade,
			"verbose" => \$verbose,
			"help" => \$showHelp,
			"keepPackages" => \$keepPackages,
			"workingdir=s" => \$workingDir) || abort($TRANSLATABLE_ERRORS[0]);

	if($showHelp == 1) {
		showHelp();
	}

	if($upgrade == 1) {
		$update = 1;
	}

	if($update == 1
	   && $installDir eq "") {
		abort($TRANSLATABLE_ERRORS[1]);
	}

	if($installDir ne "") {
		$changeInstallDir=0;
	}
}



######################################################################################################################
# Prüft das Arbeitsverzeichnis
######################################################################################################################
sub checkWorkingDir {
	my $testFileName = "test";
	my $testFilePath = $testFileName;

	if($workingDir ne "") {
		if(!opendir(DIR, $workingDir)) {
			abort($TRANSLATABLE_ERRORS[2], $workingDir);
		} else {
			closedir(DIR);
		}
		$testFilePath = $workingDir."/".$testFileName;
	}

	if(!open(TEST_FILE, ">", $testFilePath)) {
		$workingDir = "/tmp";
		$testFilePath = $workingDir."/".$testFileName;

		if(!open(TEST_FILE, ">", $testFilePath)) {
			abort($TRANSLATABLE_ERRORS[3]);
		} else {
			close(TEST_FILE);
			unlink($testFilePath);
		}
	} else {
		close(TEST_FILE);
		unlink($testFilePath);
	}
}



######################################################################################################################
# Prüfe ob benötigte Programme da sind
######################################################################################################################
sub checkProgramms {
	foreach (@REQUIRED_PROGRAMMS) {
		my $status = system("which $_ > /dev/null 2>&1");

		if($status != 0) {
                    abort($TRANSLATABLE_ERRORS[4], $_);
		}
	}
}



######################################################################################################################
# Zeigt die EULA an
######################################################################################################################
sub showEula {
	if($FILE_EULA ne "" && $update == 0) {
		if(!open(EULA, "<", $FILE_EULA)) {
			abort($TRANSLATABLE_ERRORS[5], $FILE_EULA);
		}
		close EULA;
		printf($TRANSLATABLE[5]);
		my $answer = <STDIN>;

		system("less $FILE_EULA");

		printf($TRANSLATABLE[6], $TRANSLATABLE[0], uc($TRANSLATABLE[2]));
		chomp($answer = <STDIN>);
		$answer=lc($answer);

		my $found = 0;
		foreach(@ANSWER_YES_LIST) {
			if($answer eq $_) {
				$found = 1;
				last;
			}
		}

		if($found == 0) {
			abort($TRANSLATABLE_ERRORS[6], sprintf($TRANSLATABLE[7], $APPLICATION_NAME));
		}
	}
}



######################################################################################################################
# Installationsverzeichniss erfragen
######################################################################################################################
sub getInstallDir {
	if($update == 0 && $changeInstallDir == 1) {
		while(1) {
			if($> == 0) {
				# Root User
				$installDir = "/opt/".$INSTALL_DIR_DEF;
			} else {
				# Normaler Benutzer
				$installDir = $ENV{"HOME"}."/".$INSTALL_DIR_DEF;
			}

			printf($TRANSLATABLE[8], $APPLICATION_NAME, $installDir);
			my $answer = <STDIN>;
			chomp($answer);

			if($answer ne "") {
				$installDir = $answer;
			}

			# vorne und hinten Leerzeichen abschneiden
			$installDir =~ s/^\s+//;
			$installDir =~ s/\s+$//;

			# Jetzt ersetzen wir noch die Tilde durch das Home-Verzeichnis
			$installDir =~ s/^~/$ENV{"HOME"}/;

			# einen relativen Pfad um den aktuellen Pfad erweitern
			if($installDir =~ m/^[^\/]/) {
				$installDir = $ENV{"PWD"}."/".$installDir;
			}

			my $dirCreated = 0;
			if(! -e $installDir) {
				printf($TRANSLATABLE[19], uc($TRANSLATABLE[0]), $TRANSLATABLE[2]);
				my $createAnswer = <STDIN>;
				chomp($createAnswer);
				$createAnswer=lc($createAnswer);

				my $found = 1;
				foreach(@ANSWER_NO_LIST) {
					if($createAnswer eq $_) {
						$found = 0;
						last;
					}
				}

				if($found == 1) {
					# Installationsverzeichniss anlegen
					eval { mkpath($installDir."/".$LOG_FILE_DIR) };

					$dirCreated = 1;

					if($@) {
						printf(red($TRANSLATABLE_ERRORS[12]), $installDir);
						next;
					}
				} else {
					next;
				}
			}

			my $symlinkTestFile = $installDir."/symlinks_possible";
			my $symlinks_possible = symlink($symlinkTestFile, $symlinkTestFile);

			if($symlinks_possible) {
				unlink $symlinkTestFile;
				last;
			} else {
				if($dirCreated == 1) {
					rmtree($installDir);
				}
				abort($TRANSLATABLE_ERRORS[7], $APPLICATION_NAME);
			}
		}
	}
}



######################################################################################################################
# Holt die Index-Datei
######################################################################################################################
sub getIndexFile {
	my $downloaded = 0;
	my $answer = 1;

	$fileName = basename($INDEX_FILE_PATH_ON_SERVER);

	if(! -e $fileName
		|| -s $fileName == 0) {
		# Hole Indexdatei aus dem Netz.

		# Wenn wir ein Arbeitsverzeichnis haben schreiben wir dahin.
		if($workingDir ne "") {
			$fileName = $workingDir."/".$fileName;
		}

		if($verbose == 0) {
			$answer = system("wget -T 60 -t 1 -q $DOWNLOAD_SERVER$INDEX_FILE_PATH_ON_SERVER -O $fileName");
		} else {
			$answer = system("wget -T 60 -t 1 $DOWNLOAD_SERVER$INDEX_FILE_PATH_ON_SERVER -O $fileName");
		}

		if($answer != 0
			|| -s $fileName == 0) {
			unlink($fileName);
			abort($TRANSLATABLE_ERRORS[8], $DOWNLOAD_SERVER.$INDEX_FILE_PATH_ON_SERVER);
		}

		$downloaded = 1;
	}

	if(!open(INDEX, "<", $fileName)) {
		abort($TRANSLATABLE_ERRORS[9], $fileName);
	} else {
		while(<INDEX>) {
			$indexContent.=$_;
		}

		close(INDEX);

		if($downloaded == 1 && $keepPackages == 0) {
			unlink($fileName);
		}
	}
}



######################################################################################################################
# Checkt Index-Datei und sucht die herunter zu ladenden Dateien zusammen
######################################################################################################################
sub checkIndexFile {
	my $totalSize = 0;
	my $packageString = "";
	my $machineType = `uname -m`;

	chomp($machineType);

	if($machineType eq "i686") {
		$machineType = "l";
	} elsif($machineType eq "x86_64") {
		$machineType = "l64";
	} else {
		abort($TRANSLATABLE_ERRORS[10], $machineType);
	}

	if(length($indexContent) == 0) {
		abort($TRANSLATABLE_ERRORS[17]);
	}

	foreach (split(/[\r\n]+/, $indexContent)) {
		chomp;
		if(/^(.*);(.*);(.*);(.*)$/) {
			my $filePath = $1;
			my $required = $2;
			my $what = $3;
			my $system = $4;

			if($system eq $machineType || $system eq "a") {
				$fileName = basename($filePath);

				if(! -e $installDir."/".$LOG_FILE_DIR."/".$fileName.".log") {
					# Die Datei ist noch nicht installiert.
					if( -e $fileName ) {
						# Die Datei liegt lokal vor, also brauchen wir sie nicht herunter zu laden
						push(@downloadedFiles, $fileName);
					} else {
						my $file2get;
						if($filePath =~ m/^http:/) {
							$file2get = $filePath;
						} else {
							$file2get = $DOWNLOAD_SERVER."/".$filePath;
						}
						# Die Datei muss aus dem Netz gezogen werden. Schreiben wir mal raus wie viel da herunter geladen werden muss.
						my $spider = `export LANG=C;export LC_MESSAGES=C;wget --spider $file2get 2>&1`;
						my ($size, $dummy, $mb, $mime)	= $spider=~/Length:\s+([\d\.,]+)\s+(\(([\d\.,]+[MK]?)\))?\s*(\[.*\])/;
						my $string = sprintf($TRANSLATABLE[14], $what, $mime, $size, $mb);
						$packageString .= $string;
						push(@filesToDownload, $_);
						$size=~s/[\.,]//g;
						$totalSize += $size;
					}
				}
			}
		}
	}

	if((scalar @filesToDownload) != 0) {
		printf($TRANSLATABLE[16]);
		printf($packageString);
		printf($TRANSLATABLE[15], $totalSize/(1024*1024));
	}
}



######################################################################################################################
# Roleback
######################################################################################################################
sub roleback {
	my ($fileName) = @_;
	$fileName =~ /^$CLIENTID-(.*)_.*$/;
	my $packageName = $1;

	if(opendir(LOG_FILE_DIR, $installDir."/".$LOG_FILE_DIR)) {
		my @allFiles=readdir(LOG_FILE_DIR);
		@allFiles=grep(!/^\./, @allFiles);

		close(LOG_FILE_DIR);

		foreach(@allFiles) {
			$_ =~ /^$CLIENTID-(.*)_.*$/;

			if($1 eq $packageName) {
				removePackage($_);
			}
		}
	}
}



######################################################################################################################
# Lösche Dateien aus einem Logfile und das Logfile selbst
######################################################################################################################
sub removePackage {
	my ($logFile) = @_;
	my @files;
	my @dirs;

	if(open(LOG_FILE, "<", $installDir."/".$LOG_FILE_DIR."/".$logFile)) {
		while(<LOG_FILE>) {
			if(/^\s*inflating:\s+(.*)/) {
				my $file = $1;
				$file =~ s/^\s+|\s+$//;
				push(@files, $file);
			}
			if(/^\s*creating:\s+(.*)\s*$/) {
				push(@dirs, $1);
			}
		}
		close LOG_FILE;
	}

	# Füge das Logfile zur Liste der zu löschenden Dateien hinzu.
	push(@files, $installDir."/".$LOG_FILE_DIR."/".$logFile);

	unlink(@files);

	@dirs = reverse @dirs;
	foreach(@dirs) {
		rmdir $_;
	}
}



######################################################################################################################
# Lädt alle Dateien aus der Index-Datei herunter
######################################################################################################################
sub downloadFiles {
	if((scalar @filesToDownload) != 0) {
		if($update == 0) {
			my $answer;

			printf($TRANSLATABLE[9], uc($TRANSLATABLE[0]), $TRANSLATABLE[2]);

			chomp($answer = <STDIN>);
			$answer = lc($answer);

			foreach(@ANSWER_NO_LIST) {
				if($answer eq $_) {
					exit 1;
					last;
				}
			}
		}

		triggerCountPixel($DOWNLOAD_START_URL);

		# Herunterladen der Dateien
		foreach(@filesToDownload) {
			chomp;
			$_ =~ /^(.*);.*;(.*);.*$/;
			my $filePath = $1;
			my $what = $2;
			my $error = 0;
			my $retry = 1;

			$fileName = basename($filePath);

			if($workingDir ne "") {
				$fileName = $workingDir."/".$fileName;
			}

			printf($TRANSLATABLE[10], $what);

			while($retry == 1) {
				my $result = 1;
				my $file2get;

				if( $filePath =~ m/^http:/) {
				   $file2get = $filePath;
				} else {
				   $file2get = $DOWNLOAD_SERVER."/".$filePath;
				}


				if($verbose == 0) {
					$result = system("wget -q $file2get -O $fileName");
				} else {
					$result = system("wget $file2get -O $fileName");
				}

				if($result == 0) {
					# Extrahiere MD5 Summe
					$fileName =~ /^.*_(.*).zip$/;
					my $md5sum = $1;

					# Berechne MD5 Summe der Datei
					$result = `md5sum $fileName`;
					$result =~ /^(\w*)\s+.*$/;
					my $fileMd5sum = $1;

					if($md5sum ne $fileMd5sum) {
						printf(red($TRANSLATABLE_ERRORS[15]), $fileName);
						$error = 1;
					} else {
						push(@downloadedFiles, $fileName);
						push(@filesToRemove, $fileName);
						$retry = 0;
					}
				} else {
					printf(red($TRANSLATABLE_ERRORS[16]), $file2get, $fileName);
					$error = 1;
				}

				if($update == 0 && $error == 1) {
					my $answer;
					printf($TRANSLATABLE[13], $TRANSLATABLE[0], uc($TRANSLATABLE[2]));
					chomp($answer = <STDIN>);
					$answer = lc($answer);

					$retry = 0;
					foreach(@ANSWER_YES_LIST) {
						if($answer eq $_) {
							$retry = 1;
							$error = 0;
							last;
						}
					}
				} elsif($update == 1 && $error == 1) {
					# Wir haben keine Konsole und können keine Eingabe entgegen nehmen.
					# Deshalb brechen wir ab.
					$retry = 0;
				}
			}

			if($error == 1) {
				unlink $fileName;
				abort($TRANSLATABLE_ERRORS[11], $fileName);
			}
		}

		triggerCountPixel($DOWNLOAD_COMPLETE_URL);
	}
}



######################################################################################################################
# Prüfen und entpacken der Dateien
######################################################################################################################
sub unpackFiles {
	if((scalar @downloadedFiles) != 0) {
		printf($TRANSLATABLE[11]);

		# Installationsverzeichniss anlegen
		eval { mkpath($installDir."/".$LOG_FILE_DIR) };

		if($@) {
			abort($TRANSLATABLE_ERRORS[12], $installDir);
		}

		# Entpacken der Dateien
		foreach (@downloadedFiles) {
			$fileName = $_;
			my $fileBaseName = basename($fileName);

			# Hier können wir eine evtl. installierte Vorgängerversion löschen.
			# Die md5 Summen aller Downloads stimmen, also sollten sich alle Pakete entpaken lassen
			roleback($fileBaseName);

			my $result = 0;
			my @unzipReturn;
			@unzipReturn = `unzip -o -d '$installDir' $fileName 2>&1`;

			foreach(@unzipReturn) {
				if(/^\s*error:/) {
					$result = 1;
				}
				elsif(/cannot find/) {
					$result = 1;
				}
			}

			if(open(OUT, ">", $installDir."/".$LOG_FILE_DIR."/".$fileBaseName.".log")) {
				print OUT  @unzipReturn;
				close(OUT);
			}

			if($result != 0) {
				abort($TRANSLATABLE_ERRORS[13], $fileName);
			}
		}
	}
}



######################################################################################################################
# Icons für Mimetyp und Application erzeugen
######################################################################################################################
sub createIcons {
	my $mimeTypeFileName = $MIME_TYPE;
	$mimeTypeFileName =~ tr:/:-:;

	my @sizes = (16, 22, 24, 32, 48, 64, 128);

	system("\"$installDir/IconExtractor\" \"$installDir$DESKTOP_ICON_PATH\" @sizes > /dev/null 2>&1");

	foreach(@sizes) {
		my $iconFileName = "cewe_".$_.".png";
		system("xdg-icon-resource install --noupdate --theme hicolor --context apps --size $_ $iconFileName $APP_ICON_FILE_NAME");
		system("xdg-icon-resource install --noupdate --theme hicolor --context mimetypes --size $_ $iconFileName $mimeTypeFileName");
		unlink($iconFileName);
	}

	system("xdg-icon-resource forceupdate");
}



######################################################################################################################
# Informationen zum Mimetyp erzeugen.
######################################################################################################################
sub createMimeType()
{
	my $mimeTypeFileName = $MIME_TYPE.'.xml';
	$mimeTypeFileName =~ tr:/:-:;

	# Wenn wir ein Arbeitsverzeichnis haben schreiben wir dahin.
	if($workingDir ne "") {
		$mimeTypeFileName = $workingDir."/".$mimeTypeFileName;
	}

	if(!open(MIME_TYPE_FILE, ">", "$mimeTypeFileName")) {
		abort($TRANSLATABLE_ERRORS[9], $mimeTypeFileName);
	} else {
		printf(MIME_TYPE_FILE $MIME_TYPE_FILE_FORMAT, $MIME_TYPE, $APPLICATION_NAME);
		close(MIME_TYPE_FILE);

		system("xdg-mime install \"$mimeTypeFileName\"");
	}

	unlink($mimeTypeFileName);
}



######################################################################################################################
# Einträge im Startmenü erzeugen
######################################################################################################################
sub createDesktopShortcuts {
	my $desktopFileName = $MIME_TYPE.".desktop";
	$desktopFileName =~ tr:/:-:;

	# Wenn wir ein Arbeitsverzeichnis haben schreiben wir dahin.
	if($workingDir ne "") {
		$desktopFileName = $workingDir."/".$desktopFileName;
	}

	if(!open(DESKTOP_FILE, ">", $desktopFileName)) {
		abort($TRANSLATABLE_ERRORS[9], $desktopFileName);
	} else {
		printf(DESKTOP_FILE $DESKTOP_FILE_FORMAT, $installDir, $installDir, $installDir);
		close(DESKTOP_FILE);

		system("xdg-desktop-menu install --novendor \"$desktopFileName\"");
		system("xdg-desktop-icon install --novendor \"$desktopFileName\"");
	}

	unlink($desktopFileName);
}



######################################################################################################################
# Aufräumen + Abschließende Arbeiten
######################################################################################################################
sub cleanup {
	# Entferne Installationspakete
	if($keepPackages == 0) {
		unlink(@filesToRemove);
	} else {
		if($workingDir ne "") {
			# Script und EULA auch dahin kopieren.
			my @installerFiles;
			push(@installerFiles, "install.pl");
			push(@installerFiles, $FILE_EULA);
			push(@installerFiles, basename($INDEX_FILE_PATH_ON_SERVER));

			foreach(@installerFiles) {
				if(!copy($_, $workingDir."/".$_)) {
					printf($TRANSLATABLE_ERRORS[14], $_, $workingDir."/".$_);
				}
			}
			printf($TRANSLATABLE[18], $workingDir);
		} else {
			printf($TRANSLATABLE[17]);
		}
	}

	# Erzeuge Symlinks für Libs
	if(opendir(INSTALL_DIR, $installDir)) {
		chdir($installDir);
		my @allFiles=sort{ $a cmp $b } readdir(INSTALL_DIR);

		# Werfe alle Einträge mit einem Punkt am Anfang weg
		@allFiles=grep(!/^\./, @allFiles);
		my @libFiles=grep(/.+\.so\.\w*/, @allFiles);

		foreach(@libFiles) {
			my $fileName = $_;
			$fileName =~ /(.+\.so)\.(.*)/;
			my $baseFileName = $1;
			my $version = $2;

			my @v = split(/\./, $version);

			unlink($baseFileName);
			symlink($fileName, $baseFileName);
			foreach(@v) {
				$baseFileName.=".".$_;
				if($baseFileName ne $fileName) {
					unlink($baseFileName);
					symlink($fileName, $baseFileName);
				}
			}
		}

		# Ändere Dateirechte
		my @binarys;
		push(@binarys, $APPLICATION_NAME);
		push(@binarys, $PROGRAM_NAME_FOTOSHOW);
		push(@binarys, "assistant");
		push(@binarys, "facedetection");
		push(@binarys, "IconExtractor");
		push(@binarys, "QtWebEngineProcess");
		push(@binarys, "QtWebPluginProcess");
		push(@binarys, "QtWebProcess");

		chmod 0755, @binarys;

		closedir(INSTALL_DIR);
	}

	if($AFFILIATE_ID ne '') {
		if(open(SERVICESXML, ">", $installDir.$SERVICES_XML_PATH)) {
			printf SERVICESXML $SERVICES_XML_FORMAT, $AFFILIATE_ID;
			close(SERVICESXML);
		}
	}
}



######################################################################################################################
# Zählpixel URL aufrufen und die dabei heruntergeladene Datei löschen.
######################################################################################################################
sub triggerCountPixel {
	my $pixelFile = "pixel";

	if($upgrade == 1) {
		$_[0] =~ s/<update>/genericupgrade/;
	} elsif($update == 1) {
		$_[0] =~ s/<update>/update/;
	} else {
		$_[0] =~ s/<update>//;
	}

	if($workingDir ne "") {
		$pixelFile = $workingDir."/".$pixelFile;
	}

	system("wget -q $_[0] -O $pixelFile");
	unlink $pixelFile
}



######################################################################################################################
# Meldung in rot.
######################################################################################################################
sub red {
	my $message = $_[0];
	my $retVal  = sprintf("\033[31m%s\033[0m", $message);
	return $retVal;
}



######################################################################################################################
# Fehlermeldung ausgeben und abbrechen
######################################################################################################################
sub abort {
	my $message = shift(@_);

	printf(red($message), @_);

	exit 1;
}



######################################################################################################################
# Übersetzungen laden
######################################################################################################################
sub loadTranslations {
	if(open(TRANSLATIONS, "<", "install-linux-translations.pl")) {
		my $translationCode;

		while(<TRANSLATIONS>) {
			$translationCode.=$_;
		}

		close(TRANSLATIONS);

		eval($translationCode);

		@ANSWER_YES_LIST = ($TRANSLATABLE[0], $TRANSLATABLE[1]);
		@ANSWER_NO_LIST  = ($TRANSLATABLE[2], $TRANSLATABLE[3]);
	}
}


######################################################################################################################
# MAIN
######################################################################################################################
# Erzwinge eine Leerung der Puffer nach jeder print()-Operation
$| = 1;

system("clear");

loadTranslations();
getOptions();
printf($TRANSLATABLE[4], $APPLICATION_NAME);
checkWorkingDir();
checkProgramms();
#showEula();
getInstallDir();
getIndexFile();
checkIndexFile();
downloadFiles();
unpackFiles();
cleanup();
createIcons();
createMimeType();
createDesktopShortcuts();
triggerCountPixel($INSTALLATION_COMPLETE_URL);
printf($TRANSLATABLE[12], $APPLICATION_NAME, $installDir."/".$APPLICATION_NAME);
