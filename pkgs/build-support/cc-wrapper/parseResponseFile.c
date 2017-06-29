#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef enum {
  UNQUOTED,
  SINGLE_QUOTED,
  DOUBLE_QUOTED
} quote_state;

typedef enum {
  BEFORE_FIRST_WORD,
  IN_WORD,
  AFTER_WORD
} word_break_state;

void emitWordChar(word_break_state *w, char c) {
  switch(*w) { // Note: These all fall through
  case AFTER_WORD:
    putchar(' ');
  case BEFORE_FIRST_WORD:
    putchar('\'');
    *w = IN_WORD;
  case IN_WORD:
    if(c == '\'') {
      printf("'\\''");
    } else {
      putchar(c);
    }
  }
}

void emitWordEnd(word_break_state *w) {
  if(*w == IN_WORD) {
    putchar('\'');
    *w = AFTER_WORD;
  } // Otherwise, the state remains the same
}

typedef struct {
  word_break_state *w;
  char *subFilename; // Non-null if we're currently accumulating a response file name
  size_t subFilenameUsed; // If subFilename == 0, this should be 0; this should always be less than (subFilenameAllocated - 1), to allow room for the null byte
  size_t subFilenameAllocated; // If subFilename == 0, this should be 0
} file_state; // The state of parsing a single file

static const unsigned int INITIAL_SUB_FILENAME_CHARS = 32; // Arbitrary, but must be > 0

void *exitIfNull(void *p) {
  if(!p) {
    fprintf(stderr, "Out of memory");
    exit(2);
  }
  return p;
}

void wordChar(file_state *s, char c) {
  if(s->subFilename) { // We're accumulating a file to recursively process
    // Allocate more space if we need to
    if(s->subFilenameUsed >= s->subFilenameAllocated - 1) {
      size_t newSize = s->subFilenameAllocated * 2;
      s->subFilename = exitIfNull(realloc(s->subFilename, newSize));
      s->subFilenameAllocated = newSize;
    }
    s->subFilename[s->subFilenameUsed++] = c;
  } else if(*s->w != IN_WORD && c == '@') { // This is the first letter in the word; note that even quoted or escaped @'s are recursively interpreted
    s->subFilename = exitIfNull(malloc(INITIAL_SUB_FILENAME_CHARS * sizeof(*(s->subFilename))));
    assert(s->subFilenameUsed == 0);
    assert(s->subFilenameAllocated == 0);
    s->subFilenameAllocated = INITIAL_SUB_FILENAME_CHARS;
  } else {
    emitWordChar(s->w, c);
  }
}

void processFile(word_break_state *w, const char *filename);

void endWord(file_state *s) {
  if(s->subFilename) {
    s->subFilename[s->subFilenameUsed] = '\0';

    processFile(s->w, s->subFilename);

    free(s->subFilename);
    s->subFilename = 0;
    s->subFilenameUsed = 0;
    s->subFilenameAllocated = 0;
  } else {
    emitWordEnd(s->w);
  }
}

void processFile(word_break_state *w, const char *filename) {
  FILE *h = fopen(filename, "r");
  if(!h) { //TODO: We assume it's because the file doesn't exist, but perhaps we should check for other failure cases
    emitWordChar(w, '@');
    while(*filename) {
      emitWordChar(w, *filename);
      ++filename;
    }
    emitWordEnd(w);
    return;
  }

  char c;
  quote_state q = UNQUOTED;
  file_state s = {
    .w = w,
    .subFilename = 0,
    .subFilenameUsed = 0,
    .subFilenameAllocated = 0
  };
  while((c = fgetc(h)) != EOF) {
    //fprintf(stderr, "%d\n", c);
    switch(c) {
    case '\'':
      switch(q) {
      case UNQUOTED:
        q = SINGLE_QUOTED;
        break;
      case SINGLE_QUOTED:
        q = UNQUOTED;
        break;
      case DOUBLE_QUOTED:
        wordChar(&s, '\'');
        break;
      }
      break;
    case '"':
      switch(q) {
      case UNQUOTED:
        q = DOUBLE_QUOTED;
        break;
      case SINGLE_QUOTED:
        wordChar(&s, '"');
        break;
      case DOUBLE_QUOTED:
        q = UNQUOTED;
        break;
      }
      break;
    case '\\':
      c = fgetc(h);
      if(c != EOF) {
        wordChar(&s, c);
      }
      break;
    case ' ':
    case '\t':
    case '\n':
    case '\v':
    case '\f':
    case '\r':
      if(q == UNQUOTED) {
        endWord(&s);
      } else {
        wordChar(&s, c);
      }
      break;
    default:
      wordChar(&s, c);
      break;
    }
  }

  endWord(&s);

  fclose(h);
}

int main(int argc, const char *argv[]) {
  if(argc != 2) {
    fprintf(stderr, "Usage: %s [responsefile]", argv[0]);
    return 1;
  }

  word_break_state w = BEFORE_FIRST_WORD;
  processFile(&w, argv[1]);

  return 0;
}
