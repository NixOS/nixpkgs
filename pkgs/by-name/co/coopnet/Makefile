ifndef LIB_EXT
	$(error LIB_EXT must be set)
endif

CXXFLAGS += -Wall -Werror -Wno-unused-function -std=c++11 -DJUICE_STATIC -Icommon

CXXFLAGS += $(shell pkg-config --cflags juice)
LDFLAGS += $(shell pkg-config --libs juice)

COMMON_SRC := $(wildcard common/*.cpp)
COMMON_OBJ := $(patsubst common/%.cpp, bin/o/common/%.o, $(COMMON_SRC))

CLIENT_SRC = $(wildcard client/*.cpp) $(COMMON_SRC)
CLIENT_OBJ = $(patsubst %.cpp, bin/o/%.o, $(CLIENT_SRC))

SERVER_SRC = $(wildcard server/*.cpp) $(wildcard server/extra/*.cpp) $(COMMON_SRC)
SERVER_OBJ = $(patsubst %.cpp, bin/o/%.o, $(SERVER_SRC))

default: build
.PHONY: default

bin/o/%.o: %.cpp
	mkdir -p $(@D)
	c++ $(CXXFLAGS) -c $< -o $@

LINK_COMMAND = c++ $(CXXFLAGS) $(LDFLAGS) $(LDFLAGS) -o $@ $+

bin/client: $(CLIENT_OBJ)
	mkdir -p $(@D)
	$(LINK_COMMAND)

bin/server: $(SERVER_OBJ)
	mkdir -p $(@D)
	$(LINK_COMMAND)

bin/lib/libcoopnet$(LIB_EXT): $(COMMON_OBJ)
	mkdir -p $(@D)
	$(LINK_COMMAND) -shared

build: bin/client bin/server bin/lib/libcoopnet$(LIB_EXT)
.PHONY: build
