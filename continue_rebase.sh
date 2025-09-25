#!/bin/bash

# Script to automatically continue rebase by resolving conflicts
# This script will keep running until the rebase is complete

set -e

echo "Starting automated rebase continuation..."

while true; do
    echo "Attempting to continue rebase..."
    
    # Try to continue the rebase
    if GIT_EDITOR=true git rebase --continue; then
        echo "Rebase completed successfully!"
        break
    else
        exit_code=$?
        echo "Rebase continue failed with exit code: $exit_code"
        
        # Check if we're still in a rebase
        if git status | grep -q "interactive rebase in progress"; then
            echo "Still in rebase, resolving conflicts..."
            
            # Resolve conflicts by taking the incoming changes
            git checkout --theirs .
            git add .
            
            echo "Conflicts resolved, will try again..."
        else
            echo "No longer in rebase state, exiting..."
            break
        fi
    fi
done

echo "Rebase process finished."
