package main

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strings"
)

const BinPattern = "(/usr)?/bin/(env )?{}"

var (
	flList    = flag.Bool("l", false, "list files in PATH")
	flPath    = flag.String("p", os.Getenv("PATH"), "PATH")
	flPattern = flag.String("r", BinPattern, "regex to be replaced, with {} for basename placeholder")
)

func main() {
	log.SetFlags(log.Lshortfile)
	flag.Parse()
	if _, err := regexp.Compile(*flPattern); err != nil {
		log.Fatal(err)
	}

	files := flag.Args()
	dirs := filepath.SplitList(*flPath)
	table := makeLookupTable(dirs)
	replacer := makeReplacer(*flPattern, table)

	if *flList {
		listTable(table)
	}

	for err := range pRunStrings(files, func(file string) error {
		return replaceInFile(file, replacer)
	}) {
		if err != nil {
			log.Fatal(err)
		}
	}
}

// pRunStrings runs f on each x in xs in parallel and yields errors in any order.
func pRunStrings(xs []string, f func(string) error) chan error {
	errors := make(chan error)
	queue := make(chan struct{}, runtime.NumCPU())
	results := make(chan error)
	for _, x := range xs {
		go func(x string) {
			queue <- struct{}{}
			results <- f(x)
			<-queue
		}(x)
	}
	go func() {
		for range xs {
			errors <- <-results
		}
		close(errors)
	}()
	return errors
}

// makeLookupTable returns a map from basenames to absolute paths of files in
// dirs, preferring earlier dirs on conflicts.
func makeLookupTable(dirs []string) map[string]string {
	table := map[string]string{}
	for _, reldir := range dirs {
		dir, err := filepath.Abs(reldir)
		if err != nil {
			continue
		}
		files, err := ioutil.ReadDir(dir)
		if err != nil {
			continue
		}
		for _, file := range files {
			name := file.Name()
			if table[name] == "" {
				table[name] = filepath.Join(dir, name)
			}
		}
	}
	return table
}

// listTable prints basenames and absolute paths in the table, sorted by basename.
func listTable(table map[string]string) {
	var list []string
	for name := range table {
		list = append(list, name)
	}
	sort.Strings(list)
	for _, name := range list {
		fmt.Println(name, table[name])
	}
}

// makeReplacer returns a []byte mapper that applies table translations to the
// matches of the pattern with {} replaced by a basename.
func makeReplacer(pattern string, table map[string]string) func([]byte) []byte {
	var names []string
	for name := range table {
		names = append(names, regexp.QuoteMeta(name))
	}
	alts := "(?P<basename>" + strings.Join(names, "|") + ")"
	pattern = strings.Replace(pattern, "{}", alts, -1)
	rx := regexp.MustCompile(pattern)
	rx.Longest()

	var basenameSubexps []int
	for i, s := range rx.SubexpNames() {
		if s == "basename" {
			basenameSubexps = append(basenameSubexps, i)
		}
	}

	replaceMatch := func(match []byte) []byte {
		submatches := rx.FindSubmatch(match)
		for _, i := range basenameSubexps {
			replacement := table[string(submatches[i])]
			if replacement != "" {
				return []byte(replacement)
			}
		}
		return match
	}

	return func(src []byte) []byte {
		return rx.ReplaceAllFunc(src, replaceMatch)
	}
}

// replaceInFile applies a []byte mapper to the contents of the file at path.
func replaceInFile(path string, replace func([]byte) []byte) (err error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return
	}
	replacement := replace(data)
	if bytes.Equal(replacement, data) {
		return
	}

	f, err := os.OpenFile(path, os.O_WRONLY|os.O_TRUNC, 0)
	if err != nil {
		return
	}
	defer func() {
		cerr := f.Close()
		if err == nil {
			err = cerr
		}
	}()
	_, err = f.Write(replacement)
	return
}
