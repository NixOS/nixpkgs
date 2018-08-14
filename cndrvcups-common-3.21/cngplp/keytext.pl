#
# Modified by Canon INC. on Jul. 2010
# [Change Log]
# add to get multiple res files's content.
#
#!/usr/bin/perl

my $basedir = 'files/';
my $pattern = 'res$';

my @files = ();
my @dirs = ($basedir);
die "error $basedir: $!" unless(-d $basedir);

# recursively find all files
while(@dirs){
	$d = $dirs[0];
 	$d .= "/" unless($d=~/\/$/);
 	for my $f (glob($d . '*')){
  		push(@dirs, $f) if(-d $f) ;
  		push(@files,$f) if(-f $f && $f=~/$pattern/);
 	}
	shift @dirs;
}

while(@files){
	$f = $files[0];
	open(FH,$f);
  	while(<FH>) {
		$keytext = $keytext.$_;
  	}

  	$keytext =~ /<(KeyTextList)>([\w\W]*?)<\/\1>/i;
  	$itemlist = $2;

	while ($itemlist =~ /<(Item)([\w\W]*?)>([\w\W]*?)<\/\1>/ig) {
		$item = $2;
		$text = $3;

		$text =~ s/\"/\\\"/g;
		$text =~ s/\&amp;/&/g;

		$item =~ /key *= *\" *([\w]*?) *\"/i;
		$key = $1;

		if ( length $text > 0 ){
			print "gchar \*s = N_\(\"";
			$count = 0;
		
			while ( $text =~ /(^.*)/mg ){
				$line = $1;
				$next = $';

				if ( $count != 0 ) {
					print "\"\n";
					print "              \"";
				}
			
				if ( ($line eq "") && ($next eq "") ){
					print "parse error.\n";
				}

				if ( $line ne "" ){
					print $line;
				}
	
				if ( $next =~ /^\n/ ){
					print "\\n";
				}
	
				$count++;
			}
	
			print "\"\)\;\n";
		}
	}
	close(FH);
	shift @files;
	$keytext = "";
}
