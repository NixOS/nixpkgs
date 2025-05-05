use strict;
use File::Basename;

my $src = $ENV{"src"};
my $out = $ENV{"out"};
my $path = $ENV{"searchRelativeTo"};

open OUT, ">$out" or die;
print OUT "[\n";

open FILE, "< $src" or die;

sub addName {
    my ($type, $name) = @_;
    print OUT "{ type = \"$type\"; name = \"$name\"; }\n";
}
    
while (<FILE>) {
    if (/\\input\{(.*)\}/) {
        my $fn2 = $1;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "tex", "$fn2";
    } elsif (/\\input (.*)$/) {
        my $fn2 = $1;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "tex", "$fn2";
    } elsif (/\\RequirePackage(\[.*\])?\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "misc", "$fn2.sty";
    } elsif (/\\usepackage(\[.*\])?\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "misc", "$fn2.sty";
    } elsif (/\\documentclass(\[.*\])?\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "misc", "$fn2.cls";
    } elsif (/\\bibliographystyle\{(.*)\}/) {
        my $fn2 = $1;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "misc", "$fn2.bst";
    } elsif (/\\bibliography\{(.*)\}/) {
        foreach my $bib (split /,/, $1) {
            $bib =~ s/^\s+//; # remove leading / trailing whitespace
            $bib =~ s/\s+$//;
            addName "misc", "$bib.bib";
            addName "misc", (basename($ENV{"rootFile"}, ".tex", ".ltx") . ".bbl");
        }
    } elsif (/\\includegraphics(\[.*\])?\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "img", "$fn2";
    } elsif (/\\pgfdeclareimage(\[.*\])?\{.*\}\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "img", "$fn2";
    } elsif (/\\pgfimage(\[.*\])?\{(.*)\}/) {
        my $fn2 = $2;
        die "absolute path! $fn2" if substr($fn2, 0, 1) eq "/";
        addName "img", "$fn2";
    }
    # !!! also support \usepackage
}

close FILE;

print OUT "]\n";
close OUT;
